defmodule Mintacoin.Assets.Crypto.Spec do
  @moduledoc """
  Defines contracts for the transactions available for asset crypto
  """

  alias Mintacoin.Assets.Crypto.AssetResponse

  @type opts :: Keyword.t()
  @type response :: {:ok, AssetResponse.t()} | {:error, map()}

  @callback create_asset(opts()) :: response()
end
