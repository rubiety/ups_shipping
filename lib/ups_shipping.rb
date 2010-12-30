$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'active_support'

require 'ups_shipping/configuration'
require 'ups_shipping/connection'
require 'ups_shipping/request'
require 'ups_shipping/response'

require 'ups_shipping/shipment_accept_request'
require 'ups_shipping/shipment_accept_response'
require 'ups_shipping/shipment_confirm_request'
require 'ups_shipping/shipment_confirm_response'
require 'ups_shipping/void_shipment_request'
require 'ups_shipping/void_shipment_response'

require 'ups_shipping/package'