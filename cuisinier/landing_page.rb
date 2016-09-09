class LandingPage
	attr_accessor :controller_name, :view_name

	def initialize(controller_name='welcome', view_name='home')
		@controller_name = controller_name.downcase
		@view_name = view_name.downcase
	end

	def cook
	  recipe =  "#{create_controller}\n#{define_root}"
	end

	def create_controller
		"generate :controller, '#{@controller_name}', '#{@view_name}'"
	end

	def define_root
	<<ROOT
gsub_file "config/routes.rb", "  get '#{@controller_name}/#{@view_name}'", "  root '#{@controller_name}##{@view_name}'"
ROOT
	end
end