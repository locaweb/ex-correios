ExUnit.start()

Application.ensure_all_started(:bypass)
{:ok, _} = Application.ensure_all_started(:ex_machina)
