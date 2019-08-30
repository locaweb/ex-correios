defmodule ExCorreios.Factory do
  @moduledoc false

  use ExMachina

  alias ExCorreios.Shipping.Packages.PackageItem
  alias ExCorreios.Shipping.{Service, Shipping}

  def package_item_factory do
    %PackageItem{diameter: 40, width: 11.0, height: 2.0, length: 16.0, weight: 0.3}
  end

  def shipping_factory do
    %Shipping{
      declared_value: 0,
      destination: "05724005",
      enterprise: "",
      manually_entered: false,
      origin: "08720030",
      package: package_item_factory(),
      password: "",
      receiving_alert: false,
      services: Service.get_service(:pac)
    }
  end
end
