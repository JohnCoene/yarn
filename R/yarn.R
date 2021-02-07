#' Install yarn
#' 
#' Install yarn.
#' 
#' @importFrom npm npm_install
#' @export
install_yarn <- function(){
  npm_install("yarn", scope = "global")
}

#' Yarn Run
#' 
#' @param ... arguments to pass to the `yarn` command.
#' 
#' @importFrom erratum jab enforce w e
#' 
#' @export
yarn_run <- function(...){
  output <- jab(
    system_2(...),
    w = function(w){
      NULL
    },
    e = e("failed to run command")
  )
  enforce(output)
  invisible(output)
}

#' @keywords internal
#' @importFrom cli cli_process_start cli_process_failed cli_process_done
#' @importFrom erratum jab w e is.e is.w
yarn_run_process <- function(..., s, d, f){
  cli_process_start(s, d, f)
  output <- jab(
    system_2(...),
    w = function(w){
      cli_process_done()
      NULL
    },
    e = function(e){
      cli_process_failed()
      e("failed to run command")
    }
  )
  
  if(is.e(output) || is.w(output))
    return()

  cli_process_done()
  
  invisible(output)
}

#' @keywords internal
system_2 <- function(...){
  system2("yarn", c(...), stdout = TRUE, stderr = TRUE)
}

#' Yarn Init
#' 
#' @export 
yarn_init <- function(){
  yarn_run_process(
    "init", "-y",
    s = "Initialising yarn",
    d = "Initialised yarn",
    f = "Failed to initialise yarn"
  )
}

#' Yarn Install
#' 
#' @param ... Names of packages to install.
#' @param scope Scope of the installation of the packages.
#' 
#' @name yarn_add
#' 
#' @export 
yarn_add <- function(
  ..., 
  scope = c(
    "dev", 
    "prod", 
    "peer",
    "tilde",
    "exact",
    "global",
    "optional"
  )
){
  
  msgs <- package_message(...)
  scope <- match.arg(scope)
  if(scope == "global")
    yarn_run_process("add", "global", ..., s = msgs$s, d = msgs$d, f = msgs$f)
  else
    yarn_run_process("add", ..., scope, s = msgs$s, d = msgs$d, f = msgs$f)
}

#' @describeIn yarn_add Install dependencies from project.
#' @export 
yarn_install  <- function(){
  yarn_run_process(
    "install",
    s = "Installing dependencies", 
    d = "Installed dependencies", 
    f = "Failed to install dependencies"
  )
}

#' @keywords internal
scope2flag <- function(scope = c("dev", "prod")){
  scope <- match.arg(scope)

  switch(
    scope,
    dev = "--dev", 
    prod = "", 
    peer = "--peer",
    tilde = "--tilde",
    exact = "--exact",
    optional = "--optional"
  )
}

#' Package Installation Messages
#' 
#' Creates messages for installation process.
#' 
#' @keywords internal
package_message <- function(...){
  pkgs_flat <- packages_flat(...)

  list(
    s = sprintf("Installing %s", pkgs_flat),
    d = sprintf("Installed %s", pkgs_flat),
    f = sprintf("Failed to installed %s", pkgs_flat)
  )
}

#' Flatten Packages
#' 
#' Flatten packages for creating the message.
#' 
#' @keywords internal
packages_flat <- function(...){
  pkgs <- c(...)

  if(length(pkgs) == 0)
    pkgs <- "packages from {.val `package.json`}"
  else 
    pkgs <- sapply(pkgs, function(pak){
      sprintf("{.val `%s`}", pak)
    })

  paste0(pkgs, collapse = ", ")
}
