require 'escpos'
require "libusb"

usb = LIBUSB::Context.new
device = usb.devices(idVendor: 0x0416, idProduct: 0x5011).first
device.open_interface(0) do |handle|
  handle.control_transfer(bmRequestType: 0x40, bRequest: 0xa0, wValue: 0xe600, wIndex: 0x0000, dataOut: 1.chr)
end

@printer = Escpos::Printer.new
@printer << "Some Text"
@printer << Escpos::Helpers.big("Big text")

puts @printer.to_escpos # returns ESC/POS data ready to be sent to printer
# on linux this can be piped directly to /dev/usb/lp0
# with network printer sent directly to printer socket
# with serial port printer it can be sent directly to the serial port

@printer.to_base64 # returns base64 encoded ESC/POS data

