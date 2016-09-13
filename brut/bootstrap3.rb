gem 'bootstrap-sass', '~> 3.3.6'

if File.file? 'app/assets/stylesheets/application.css' 
	run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss'
end

gsub_file 'app/assets/stylesheets/application.scss', '*= require_tree .', ''
gsub_file 'app/assets/stylesheets/application.scss', '*= require_self', ''

inject_into_file 'app/assets/stylesheets/application.scss',"@import 'bootstrap-sprockets';\n@import 'bootstrap-modules';\n", before: /^.*$/m
inject_into_file 'app/assets/javascripts/application.js', "//= require bootstrap-sprockets\n", after: "//= require jquery\n"

run 'touch app/assets/stylesheets/_bootstrap-modules.scss'

inject_into_file 'app/assets/stylesheets/_bootstrap-modules.scss', before: /^.*$/m do <<-'MODULES'
/*!
 * Bootstrap v3.3.7 (http://getbootstrap.com)
 * Copyright 2011-2016 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 */

// Core variables and mixins
@import "bootstrap/variables";
@import "bootstrap/mixins";

// Reset and dependencies
@import "bootstrap/normalize";
@import "bootstrap/print";
@import "bootstrap/glyphicons";

// Core CSS
@import "bootstrap/scaffolding";
@import "bootstrap/type";
@import "bootstrap/code";
@import "bootstrap/grid";
@import "bootstrap/tables";
@import "bootstrap/forms";
@import "bootstrap/buttons";

// Components
@import "bootstrap/component-animations";
@import "bootstrap/dropdowns";
@import "bootstrap/button-groups";
@import "bootstrap/input-groups";
@import "bootstrap/navs";
@import "bootstrap/navbar";
@import "bootstrap/breadcrumbs";
@import "bootstrap/pagination";
@import "bootstrap/pager";
@import "bootstrap/labels";
@import "bootstrap/badges";
@import "bootstrap/jumbotron";
@import "bootstrap/thumbnails";
@import "bootstrap/alerts";
@import "bootstrap/progress-bars";
@import "bootstrap/media";
@import "bootstrap/list-group";
@import "bootstrap/panels";
@import "bootstrap/responsive-embed";
@import "bootstrap/wells";
@import "bootstrap/close";

// Components w/ JavaScript
@import "bootstrap/modals";
@import "bootstrap/tooltip";
@import "bootstrap/popovers";
@import "bootstrap/carousel";

// Utility classes
@import "bootstrap/utilities";
@import "bootstrap/responsive-utilities";

MODULES
end

inject_into_file 'app/views/layouts/application.html.erb', after: "  <head>\n" do <<-'SHIM'
	  <meta charset="utf-8">
	  <meta http-equiv="X-UA-Compatible" content="IE=edge">
	  <meta name="viewport" content="width=device-width, initial-scale=1">
SHIM
end

inject_into_file 'app/views/layouts/application.html.erb', before: "  </head>" do <<-'SHIM'
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
SHIM
end