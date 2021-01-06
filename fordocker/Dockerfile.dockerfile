FROM python:3.7-alpine
WORKDIR /.
COPY script.py /
EXPOSE 80
CMD [ "python", "./script.py", "/bin/bash" ]