FROM ubuntu:trusty-20150612

# install Haskell, LaTeX, and Node
RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
    ca-certificates \
    gdebi-core \
    git \
    haskell-platform \
    libapache2-mod-proxy-html \
    libcurl4-openssl-dev \
    libghc-pandoc-citeproc-data \
    libghc-pandoc-citeproc-dev \
    libghc-pandoc-citeproc-doc \
    libghc-pandoc-dev \
    libxml2-dev \
    lmodern \
    nodejs \
    qpdf \
    r-base-dev \
    r-recommended \
    texlive-fonts-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-luatex \
    texlive-xetex \
    wget

# install RStudio
ENV RSTUDIOVERSION rstudio-server-0.99.739-amd64.deb
RUN wget https://s3.amazonaws.com/rstudio-dailybuilds/$RSTUDIOVERSION
RUN gdebi --non-interactive $RSTUDIOVERSION


# install pandoc
RUN cabal update && \
    cabal install pandoc pandoc-citeproc

ENV PATH /root/.cabal/bin:$PATH