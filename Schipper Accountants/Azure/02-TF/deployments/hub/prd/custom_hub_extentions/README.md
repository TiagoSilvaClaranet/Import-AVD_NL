# Custom HUB Extention Resources

This folder contains custom HUB resources which are not yet standardized and added to the HUB deployment.

Please create a subfolder per resource or collection of resources which make up a solution.

Call these resources as a module from the HUB's custom_hub_extentions.tf like:

```` 
module "CustomResource1" {
  source    = "./custom/<folder>"
}
````