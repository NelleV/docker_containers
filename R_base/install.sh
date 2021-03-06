R_VERSION=4.0.2
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
TERM=xterm
 CRAN=https://mirror.ibcp.fr/pub/CRAN/

apt-get update
apt-get install -y libxml2-dev curl gcc gfortran g++
apt-get install -y texlive libreadline-dev libicu-dev
apt-get install -y libssl-dev libcurl4-openssl-dev  libxml2-dev  openjdk-8-jdk

BUILDDEPS="curl \
    default-jdk \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    perl \
    tcl8.6-dev \
    tk8.6-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-recommended \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    zlib1g-dev"

apt-get install -y --no-install-recommends $BUILDDEPS
cd tmp/ 
## Download source code
curl -O https://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz
## Extract source code
tar -xf R-${R_VERSION}.tar.gz
cd R-${R_VERSION}
## Set compiler flags
R_PAPERSIZE=letter
R_BATCHSAVE="--no-save --no-restore"
R_BROWSER=xdg-open
PAGER=/usr/bin/pager
PERL=/usr/bin/perl
R_UNZIPCMD=/usr/bin/unzip
R_ZIPCMD=/usr/bin/zip
R_PRINTCMD=/usr/bin/lpr
LIBnn=lib
AWK=/usr/bin/awk
CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g"
CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g"

## Configure options
./configure --enable-R-shlib \
	    --enable-memory-profiling \
	    --with-readline \
	    --with-blas \
	    --with-tcltk \
	    --disable-nls \
	    --with-recommended-packages
## Build and install
make
touch doc/NEWS.pdf
cp doc/NEWS.rds doc/NEWS.2.rds
cp doc/NEWS.rds doc/NEWS.3.rds
make install

## Add a library directory (for user-installed packages)
mkdir -p /usr/local/lib/R/site-library
chown root:staff /usr/local/lib/R/site-library
chmod g+ws /usr/local/lib/R/site-library
## Fix library path
sed -i '/^R_LIBS_USER=.*$/d' /usr/local/lib/R/etc/Renviron
echo "R_LIBS_USER=\${R_LIBS_USER-'/usr/local/lib/R/site-library'}" >> /usr/local/lib/R/etc/Renviron
echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron
## Set configured CRAN mirror
if [ -z "$BUILD_DATE" ]; then MRAN=$CRAN;
else MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE};
fi
echo MRAN=$MRAN >> /etc/environment
echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site

## Clean up from R source install
cd /
rm -rf /tmp/*
