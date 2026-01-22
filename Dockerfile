FROM python:3.12-slim 

# Prevent Python from writing .pyc files and enable stdout/stderr flushing
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

# Install system deps (if needed) and Python deps, remove unwanted dependencies and files at the end

RUN apt-get update \
 && apt-get install -y --no-install-recommends gcc libc-dev \
 && pip install --no-cache-dir -r requirements.txt \
 && apt-get remove -y gcc libc-dev \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

#copy app code and model files
COPY . .

#Train the model , train.py resides under model folder
RUN python3 model/train.py

EXPOSE 6000

CMD ["gunicorn","--workers","4","--bind","0.0.0.0:6000","app:app"]

#app:app here first refers to filename,like our file name is app.py so the name, 2nd is the app flask object