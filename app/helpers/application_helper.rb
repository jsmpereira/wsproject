module ApplicationHelper
	def check_active(path)
		path.include?(params[:controller]) ? "active" : ""
	end
	
	def default_text_field(name, value)
		text_field_tag(name, value, :onfocus => "if (this.value=='#{value}') this.value = '';", :onblur => "if (this.value=='') {this.value = '#{value}';}" )
	end
end
