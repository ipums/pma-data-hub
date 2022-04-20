# try tidyverse ----
if(!suppressWarnings(suppressMessages(require(tidyverse)))){
  rlang::abort(c(
    "tidyverse is not installed",
    "i" = "Install tidyverse with `install.packages('tidyverse')`"
  ))
}

# try ipumsr ----
if(!suppressWarnings(suppressMessages(require(ipumsr)))){
  rlang::abort(c(
    "ipumsr is not installed",
    "i" = "Install ipumsr with `install.packages('ipumsr')`"
  ))
}

# try htmltools ----
if(!suppressWarnings(suppressMessages(require(htmltools)))){
  rlang::abort(c(
    "htmltools is not installed",
    "i" = "Install htmltools with `install.packages('htmltools')`"
  ))
}

# try RCurl ----
# If RCurl is not installed, warn user that URLs cannot be validated 
if(!suppressWarnings(suppressMessages(require(RCurl)))){
  rlang::warn(c(
    "RCurl is not installed, so URLs built with `pmavar` will not be tested",
    "i" = "Before next time, install RCurl with `install.packages('RCurl')`"
  ))
}

# try here ----
if(!suppressWarnings(suppressMessages(require(here)))){
  rlang::warn(c(
    "here is not installed",
    "i" = "Install here with `install.packages('here')`"
  ))
}

# try sysfonts ----
if(!suppressWarnings(suppressMessages(require(sysfonts)))){
  rlang::abort(c(
    "sysfonts is not installed",
    "i" = "Install sysfonts with `install.packages('sysfonts')`"
  ))
} else {
  sysfonts::font_add(
    family = "cabrito",
    regular = here::here("fonts/cabritosansnormregular-webfont.ttf")
  )
}

# try showtext ----
if(!suppressWarnings(suppressMessages(require(showtext)))){
  rlang::warn(c(
    "showtext is not installed",
    "i" = "Install showtext with `install.packages('showtext')`"
  ))
} else {
  showtext::showtext_auto()
}

# varlink ----
# Build hyperlink to a variable page on pma.ipums.org 
# Optionally, select a metadata tab 
varlink <- function(varname, tab = codes){
  tab_section <- paste0(substitute(varname), "#", substitute(tab), "_section")
  url <- file.path("https://pma.ipums.org/pma-action/variables", tab_section)
  if(exists("url.exists")){
    if(!url.exists(url)){
      rlang::abort(c("x" = paste(url, "does not exist")))
    }
  }
  paste0("[", substitute(varname), "]", "(", url, ")")
}

# set_postpath ---- 
# In interactive mode, set working directory to this post's folder 
set_postpath <- function(postpath){
  if(interactive()){
    postpath <- file.path(here::here(), "_posts", postpath)
    if(getwd() != postpath){setwd(postpath)}
  }
}

# hex ---- 
# Get the hex sticker for a package (e.g. for images within aside tags)
# Must be included in `images/hex` and recorded in `images/hex/inventory.csv`
hex <- function(pkg){
  inventory <- here::here("images/hex/inventory.csv") %>% 
    read.csv() %>% 
    tibble()
  if(pkg %in% inventory$package){
    inventory <- inventory %>% filter(package == pkg)
    htmltools::div(
      htmltools::a(
        href = inventory$url,
        htmltools::img(src = file.path("../../images/hex", paste0(pkg, ".png")))
      ),
      paste("©", inventory$owner, paste0("(", inventory$license, ")"))
    )
  } else {
    rlang::abort(c(
      paste0("The `", pkg, "` package has no available hex logo"),
      "i" = "Consider downloading one to `images/hex`",
      "i" = "If you do, please add it to `images/hex/inventory.csv`" 
    ))
  }
}


