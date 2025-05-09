# Copyright (c) Alibaba, Inc. and its affiliates.
import asyncio
import os
from typing import List

os.environ['CUDA_VISIBLE_DEVICES'] = '0,1,2,3,4,5,6,7'


def infer_batch(engine: 'InferEngine', infer_requests: List['InferRequest']):
    request_config = RequestConfig(max_tokens=512, temperature=0)
    metric = InferStats()
    resp_list = engine.infer(infer_requests, request_config, metrics=[metric])
    query0 = infer_requests[0].messages[0]['content']
    print(f'query0: {query0}')
    print(f'response0: {resp_list[0].choices[0].message.content}')
    print(f'metric: {metric.compute()}')
    # metric.reset()  # reuse


def infer_async_batch(engine: 'InferEngine', infer_requests: List['InferRequest']):
    # The asynchronous interface below is equivalent to the synchronous interface above.
    request_config = RequestConfig(max_tokens=512, temperature=0)

    async def _run():
        tasks = [engine.infer_async(infer_request, request_config) for infer_request in infer_requests]
        return await asyncio.gather(*tasks)

    resp_list = asyncio.run(_run())

    query0 = infer_requests[0].messages[0]['content']
    print(f'query0: {query0}')
    print(f'response0: {resp_list[0].choices[0].message.content}')


def infer_stream(engine: 'InferEngine', infer_request: 'InferRequest'):
    request_config = RequestConfig(max_tokens=1024, temperature=0, stream=True)
    metric = InferStats()
    gen_list = engine.infer([infer_request], request_config, metrics=[metric])
    query = infer_request.messages[0]['content']
    print(f'query: {query}\nresponse: ', end='')
    for resp in gen_list[0]:
        if resp is None:
            continue
        print(resp.choices[0].delta.content, end='', flush=True)
    print()
    print(f'metric: {metric.compute()}')


if __name__ == '__main__':
    from swift.llm import InferEngine, InferRequest, PtEngine, RequestConfig, load_dataset
    from swift.plugin import InferStats
    model = '/mnt/bn/capcut-search/caomingxiang/ai_search/qwen3-32b_dense_train/output/Qwen3-dense-32B/v2-20250507-122803/checkpoint-30'
    infer_backend = 'vllm'

    if infer_backend == 'pt':
        engine = PtEngine(model, max_batch_size=64)
    elif infer_backend == 'vllm':
        from swift.llm import VllmEngine
        engine = VllmEngine(model, max_model_len=16384)
    elif infer_backend == 'lmdeploy':
        from swift.llm import LmdeployEngine
        engine = LmdeployEngine(model)

    # Here, `load_dataset` is used for convenience; `infer_batch` does not require creating a dataset.
    # dataset = load_dataset(['AI-ModelScope/alpaca-gpt4-data-zh#1000'], seed=42)[0]
    # print(f'dataset: {dataset}')
    # infer_requests = [InferRequest(**data) for data in dataset]
    # # if infer_backend in {'vllm', 'lmdeploy'}:
    # #     infer_async_batch(engine, infer_requests)
    # infer_batch(engine, infer_requests)

    # messages = [{'role': 'user', 'content': '用户导入了1个视频和4张图像，倾向于制作风格为表达勇敢争取、积极向上的卡点短片。'}]
    # messages = [{'role': 'user', 'content': '用户导入了2个视频，倾向于制作一部展现日常生活温馨细节和夏日宅家时光的治愈系Vlog，突出品质生活与精致感。音乐节奏在0.13秒、0.78秒、1.46秒、2.14秒、2.84秒、3.5秒、4.19秒、4.84秒、5.52秒、6.2秒、6.86秒、7.53秒、8.2秒、8.87秒、9.56秒、10.24秒、10.91秒、11.58秒、12.28秒、12.92秒、13.61秒、14.27秒、14.94秒、15.62秒、16.28秒、16.99秒、17.68秒、18.35秒、19.0秒、19.68秒、20.34秒和21.01秒时出现卡点。'}]
    messages = [{'role': 'user', 'content': '用户传入了4个图像，倾向于制作具有复古胶片风格的四宫格内容。'}]
    infer_stream(engine, InferRequest(messages=messages))
