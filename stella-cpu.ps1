##########################################################################################################
# Author: Peter Karacsonyi                                                                               #
# Last updated: 2024 dec 22                                                                              #
# Runner script for HuggingFace Embedding Inference Server                                               #
# Main github project site: https://github.com/huggingface/text-embeddings-inference                     #
# API endpoints: https://huggingface.github.io/text-embeddings-inference/                                #
# Tags: https://github.com/huggingface/text-embeddings-inference/pkgs/container/text-embeddings-inference#
##########################################################################################################

# There are two problems with running this on CPU (reasons why we created the quest)
# 1) Could not start Candle backend: Could not start backend: Qwen2 is only supported on Cuda devices in fp16 with flash attention enabled
# an idea to try: https://github.com/huggingface/text-embeddings-inference?tab=readme-ov-file#docker-images
[Environment]::SetEnvironmentVariable("USE_FLASH_ATTENTION", "False", "Machine")
# 2) the onnx download also had some issues - so it would need to be downloaded with the transformers downloader and exported
$image = "ghcr.io/huggingface/text-embeddings-inference:cpu-1.6-grpc"

