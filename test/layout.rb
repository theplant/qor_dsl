template "daytime", "v1", :since => "9am", :to => "12am" do
  "Hello World"
end

template "daytime", "v2", :since => "1pm", :to => "6am" do
  "Hello World2"
end

gadget :product_link, :floating => true

gadget :quick_buy, :floating => true do
  settings do
    meta :product_code, :label => "Product code", :type => :string
    meta :text, :label => "Text", :type => :string
    meta :kind, :label => "Kind", :type => :select_one, :collection => ['light', 'dark']
    meta :target, :label => "Target"
  end

  context do
    {:kind => 'light'}.merge(meta_settings.symbolize_keys).merge(:express_link => "/products/#{meta_settings[:product_code]}/#{meta_settings[:color_code]}?express=true")
  end

  template do
    <<-STRING
      <a href="{{express_link}}" class="item product_express_box action other {{kind}} btn1"><span>{{text}}</span></a>
    STRING
  end
end

action :google do
  desc "From Google"
  detect do |app|
    '...'
  end
end

layout :home do
  gadgets []
end
