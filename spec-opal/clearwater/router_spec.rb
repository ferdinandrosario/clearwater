require 'clearwater/router'
require 'ostruct'

module Clearwater
  RSpec.describe Router do
    let(:component_class) {
      Class.new do
        include Clearwater::Component
      end
    }
    let(:routed_component) { component_class.new }
    let!(:router) {
      component = routed_component
      Router.new do
        route 'articles' => component do
          route ':article_id' => component
        end
      end
    }

    it 'sets the router for a routed component' do
      expect(routed_component.router).to be router
    end

    it 'gets the params for a given path' do
      expect(router.params('/articles/foo')).to eq article_id: 'foo'
    end

    it 'gets the components for a given path' do
      expect(router.targets_for_path('/articles/1')).to eq [
        routed_component, routed_component
      ]

      expect(router.targets_for_path('/articles')).to eq [routed_component]
    end

    it 'gets the current path' do
      location = OpenStruct.new(path: '/foo')
      router = Router.new(location: location)

      expect(router.current_path).to eq '/foo'

      location.path = '/bar'

      expect(router.current_path).to eq '/bar'
    end

    it 'gets the params from the path' do
      expect(router.params('/articles/123')).to eq({ article_id: '123' })
    end
  end
end
