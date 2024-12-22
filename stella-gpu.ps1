##########################################################################################################
# Author: Peter Karacsonyi                                                                               #
# Last updated: 2024 dec 22                                                                              #
# Runner script for HuggingFace Embedding Inference Server                                               #
# Main github project site: https://github.com/huggingface/text-embeddings-inference                     #
# API endpoints: https://huggingface.github.io/text-embeddings-inference/                                #
# Tags: https://github.com/huggingface/text-embeddings-inference/pkgs/container/text-embeddings-inference#
##########################################################################################################

# WARNING: sometimes it takes 5-6 minutes for the model to start, for example:
# 2024-12-22T22:00:29.017555Z  INFO text_embeddings_backend_candle: backends/candle/src/lib.rs:373: Starting FlashQwen2 model on Cuda(CudaDevice(DeviceId(1)))
# 2024-12-22T22:05:36.201611Z  INFO text_embeddings_router: router/src/lib.rs:248: Warming up model

# Dynamically set the location to the directory of this script
Set-Location -Path $PSScriptRoot

$model = "dunzhang/stella_en_1.5B_v5"
$volume = "${PSScriptRoot}\models\" # Use the script's location for models directory
$prompt_name = "s2p_query"
# either we use the default_prompt of the name
# $default_prompt = "Instruct: Given a web search query, retrieve relevant passages that answer the query.\nQuery: "
$docker_container_name = "huggingface-embeddings-inference"
$containerport = 3000 # the huggingface server inside listens on this port
$localport = 3001
# best image reference for ADA RTX https://github.com/huggingface/text-embeddings-inference?tab=readme-ov-file#docker-images
$image = "ghcr.io/huggingface/text-embeddings-inference:89-1.6"

# would be nice to set the max token length however it is not yet implemented:
# https://github.com/huggingface/text-embeddings-inference/issues/396
# $max_input_length = 768 

docker rm $docker_container_name

# Check if anything is already listening on local port
if (Get-NetTCPConnection -LocalPort $localport -ErrorAction SilentlyContinue) {
    Write-Host "Error: Port $localport is already in use. Please stop the process using this port and try again." -ForegroundColor Red
    exit 1
}

# Run the Docker container
docker run --gpus all -p ${localport}:$containerport -v "${volume}:/data" --name $docker_container_name $image `
    --model-id $model --default-prompt-name $prompt_name --port $containerport
