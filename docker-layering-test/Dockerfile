FROM python:3.10

WORKDIR /app

RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir seaborn

RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir statsmodels

COPY script.py /app/script.py

CMD ["python", "/app/script.py"]

