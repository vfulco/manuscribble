FROM danielak/latex-xenial:latest

# Global Variables
# Making one change to RBRANCH toggles this from pre-release (R-devel) to base (current R)
ENV RBRANCH base/
ENV RVERSION R-latest
ENV CRANURL https://cran.rstudio.com/src/
# To bump a pandoc version, just update this variable. The rest are chained to it.
ENV PANDOC_VERSION 1.17.2
ENV PANDOC_LATEX_TEMPLATE pandoc-template.latex

##########################################################################
# Install Pandoc - set version in ENV PANDOC_VERSION
##########################################################################
ENV PANDOC_PACKAGE pandoc-$PANDOC_VERSION-1-amd64.deb
ENV PANDOC_URL https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/$PANDOC_PACKAGE
RUN mkdir pandoc && cd pandoc
RUN wget "$PANDOC_URL"
RUN dpkg --install $PANDOC_PACKAGE

#####################################
# Install wget
#####################################
RUN apt-get update && apt-get install --assume-yes wget

# Add R Repository for CRAN packages
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# install some basic stuff R depends upon
RUN apt-get update && apt-get install --assume-yes \
    apache2 \
    ca-certificates \
    ccache \
    gdebi \
    git \
    libcurl4-openssl-dev \
    libmysqlclient-dev \
    libpq-dev \
    libssl-dev \
    libx11-dev \
    libxml2-dev \
    lmodern \
    mysql-client \
    wget

# Get Dependencies to build R from source
RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
        r-base-dev

RUN apt-get update && apt-get build-dep --assume-yes r-base-core

RUN mkdir /manuscribble
RUN mkdir /manuscript
COPY compiling/makefile /manuscribble
COPY compiling/$PANDOC_LATEX_TEMPLATE /manuscribble
WORKDIR /manuscript
ENTRYPOINT ["make", "-C", "/manuscribble", "manuscript"]
# CMD ["ls", "-al", "/manuscript"]

# # Build R from source
# RUN wget "$CRANURL$RBRANCH$RVERSION.tar.gz" && \
#     mkdir /$RVERSION && \
#     tar --strip-components 1 -zxvf $RVERSION.tar.gz  -C /$RVERSION && \
#     cd /$RVERSION && \
#     ./configure --enable-R-shlib && \
#     make && \
#     make install
#
# # Install R packages
# COPY provisioning/r-packages.R /tmp/
# RUN R --vanilla -f /tmp/provisioning/r-packages.R
#
# # Copy R script to render a manuscript
# RUN mkdir -p /render
# COPY render_manuscript.R /render/
#
# # Set up a working directory
# RUN mkdir -p /source
# WORKDIR /source
# # ENTRYPOINT [ "R", "--vanilla", "-f", "/render/render_manuscript.R", "--args" ]
