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

import QualityRangeController from "./quality_range_controller"
application.register("quality-range", QualityRangeController)

import RemoveBgController from "./remove_bg_controller"
application.register("remove-bg", RemoveBgController)

import UploadController from "./upload_controller"
application.register("upload", UploadController)

import BackToTopController from "./back_to_top_controller"
application.register("back-to-top", BackToTopController)