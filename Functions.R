
# Create folder structure -------------------------------------------------

create_folder_structure <- function(project_name = NULL, network = FALSE, edc = FALSE){
  # check if a project name is specified. If not raise error.
  if(is.null(project_name)){stop("Error. Please specify a project name.")}
  
  # to avoid problems with whitespaces in the folder name, whitespaces are automaticcaly recoded
  # to underscores. A message is prompted in case of recoding.
  if(grepl("\\s", project_name)){
    # replace whitespace by underscore
    project_name <- gsub("\\s+", "_", project_name)
    # promt message to inform about recoding.
    message("White space in the project name is replaced by underscores.")
    }
  # name of the subfolder which should be created.
  folder_structure <- c("Data", "Results/Tables", "Results/Graphs", 
                        "Source", "Reports", "Validation", "Archive"
                        )
  
  # add the project_name to all subfolders.
  local_folder_structure <- paste0(project_name, 
                                   "/",
                                   folder_structure
                                   )
  # iterate over all folder names and create directory.
  # recursive = TRUE ensures that the project_name folder is created at start. Otherwise this would
  # raise an error.
  lapply(local_folder_structure, dir.create, recursive = TRUE)
  
  
  # Besides the local folder, it might be interesting to also create the folder on the network drive.
  if(network){
    # create the network folder structure. network drive must be specified!!!
    warning("Specify network drive!!!")
    network_projects_basic <- "~/RProjects"
    # create thw complete network folder structure
    network_folder_structure <- paste0(network_projects_basic, 
                                       project_name, 
                                       "/", 
                                       "Statistics/",
                                       folder_structure)
    # create folders.
    lapply(network_folder_structure, dir.create, recursive = TRUE)
    
    # in case the project involves an EDC system, the neccessary folders are also created.
    if(edc){
      # edc specific folders
      edc_folder_structure <- c("Documents", "Validation", "CRF")
      # create complete folder structure
      network_folder_structure <- paste0(network_projects_basic, 
                                         project_name, 
                                         "/", 
                                         "EDC/",
                                         edc_folder_structure)
      # create directories
      lapply(network_folder_structure, dir.create, recursive = TRUE)
    }
  }
  message("Directories created successfully.")
}



# Create new script -------------------------------------------------------

new_script <- function(name = NULL, type = "R"){
  
  if(is.null(name)){error("Error! Please specify a name for the script!")}
  
  if(grepl("\\s", name)){
    # replace whitespace by underscore
    name <- gsub("\\s+", "_", name)
    # promt message to inform about recoding.
    message("White space in the project name is replaced by underscores.")
  }
  
  if(!type %in% c("R", "Rmd_html", "Rmd_word")){
    error("Error! PLease check the type argument. Must be one of R, Rmd_html, Rmd_word")
  }
  
  filename <- ifelse(type == "R", paste0(name, ".R"), paste0(name,".Rmd"))
  
  if(!file.exists(filename)){
    file.create(filename)
  } else{
    error("Error! File already exists. Choose another name.")
  }
  
}
