FROM rstudio/r-base:3.6-xenial

RUN apt-get update && \
    apt-get install -y texinfo python-dev python-pip && \
    apt-get clean

RUN pip install awscli

RUN echo 'options(repos = c(CRAN = "https://demo.rstudiopm.com/all/__linux__/xenial/latest"), HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))' >> ~/.Rprofile

RUN mkdir -p /tmp/tools && \
    R -e 'install.packages("remotes", lib = "/tmp/tools")'

WORKDIR /tmp/workdir

COPY r_cmd_check /tmp/workdir

ENTRYPOINT ["./r_cmd_check"]
