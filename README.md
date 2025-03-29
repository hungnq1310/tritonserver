# Triton Server Images
Customized Triton Inference Server for streamlined deployment. 

## Use huggingface models
A script called **hf.py** is available to load models from Hugging Face, which can be executed before launching Triton Inference Server. Here is docker-compose.yml example:
```yml
# use docker secrets to encrypt hf.json to prevent huggingface token exploited.

secrets:
  hf_config_file:
    file: configs/hf.json

services:
  tritonserver:
    image: hieupth/tritonserver:24.12
    container_name: tritonserver
    restart: unless-stopped
    environment:
      HF_CONFIG_FILE: /run/secrets/hf_config_file
      HF_MODEL_REPO: /models
    secrets:
      - hf_config_file
    tty: true
    ports:
      - "8000:8000"
      - "8001:8001"
      - "8002:8002"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/v2/health/ready"]
      interval: 30s
      timeout: 5s
      retries: 2
    command: >
      bash -c "python3 -u /hf.py && tritonserver --model-repository=/models"
```
Where **hf.json** is the configuration file tell that which huggingface model repo should be downloaded:
```json
{
  "token": "abc",
  "models": [
    {
      "name": "hieupth/triton.viencoder",
      "ref": "v1",
      "token": "abc"
    }
  ]
}
```
The **HF_CONFIG_FILE** points to hf.json and **HF_MODEL_REPO** is directory that downloaded models will be saved (should be same as Triton Inference Server model repository).

## License
[GNU AGPL v3.0](LICENSE).<br>
Copyright &copy; 2024 [Hieu Pham](https://github.com/hieupth). All rights reserved.