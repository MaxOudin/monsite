// Import and register all your controllers
import { application } from "./application"

import BreadcrumbsController from "./breadcrumbs_controller"
application.register("breadcrumbs", BreadcrumbsController)

import NavbarController from "./navbar_controller"
application.register("navbar", NavbarController)

import TextFitController from "./text_fit_controller"
application.register("text_fit", TextFitController)

import SearchInputController from "./search_input_controller"
application.register("search-input", SearchInputController)