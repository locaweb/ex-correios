defmodule ExCorreios.Shipping.Service do
  @moduledoc """
  This module provides one or more services.
  """

  @available_services [
    pac: %{code: "04510", name: "PAC", description: "PAC sem contrato"},
    pac_com_contrato: %{code: "41068", name: "PAC", description: "PAC com contrato"},
    pac_com_contrato_2: %{code: "04669", name: "PAC", description: "PAC com contrato"},
    pac_gf: %{code: "41300", name: "PAC GF", description: "PAC para grandes formatos"},
    sedex: %{code: "04014", name: "SEDEX", description: "SEDEX sem contrato"},
    sedex_a_cobrar: %{
      code: "40045",
      name: "SEDEX a Cobrar",
      description: "SEDEX a Cobrar, sem contrato"
    },
    sedex_a_cobrar_com_contrato: %{
      code: "40126",
      name: "SEDEX a Cobrar",
      description: "SEDEX a Cobrar, com contrato"
    },
    sedex_10: %{code: "40215", name: "SEDEX 10", description: "SEDEX 10, sem contrato"},
    sedex_hoje: %{code: "40290", name: "SEDEX Hoje", description: "SEDEX Hoje, sem contrato"},
    sedex_com_contrato_1: %{code: "40096", name: "SEDEX", description: "SEDEX com contrato"},
    sedex_com_contrato_2: %{code: "40436", name: "SEDEX", description: "SEDEX com contrato"},
    sedex_com_contrato_3: %{code: "40444", name: "SEDEX", description: "SEDEX com contrato"},
    sedex_com_contrato_4: %{code: "40568", name: "SEDEX", description: "SEDEX com contrato"},
    sedex_com_contrato_5: %{code: "40606", name: "SEDEX", description: "SEDEX com contrato"},
    sedex_com_contrato_6: %{code: "04162", name: "SEDEX", description: "SEDEX com contrato"},
    e_sedex: %{code: "81019", name: "e-SEDEX", description: "e-SEDEX, com contrato"},
    e_sedex_prioritario: %{
      code: "81027",
      name: "e-SEDEX",
      description: "e-SEDEX Prioritário, com contrato"
    },
    e_sedex_express: %{
      code: "81035",
      name: "e-SEDEX",
      description: "e-SEDEX Express, com contrato"
    },
    e_sedex_grupo_1: %{
      code: "81868",
      name: "e-SEDEX",
      description: "(Grupo 1) e-SEDEX, com contrato"
    },
    e_sedex_grupo_2: %{
      code: "81833",
      name: "e-SEDEX",
      description: "(Grupo 2) e-SEDEX, com contrato"
    },
    e_sedex_grupo_3: %{
      code: "81850",
      name: "e-SEDEX",
      description: "(Grupo 3) e-SEDEX, com contrato"
    }
  ]

  @spec get_service(atom()) :: map()
  def get_service(service), do: @available_services[service]

  @spec get_services(list(atom)) :: list(tuple)
  def get_services(services),
    do: Enum.filter(@available_services, fn {k, _v} -> k in services end)
end
