defmodule Mintacoin.Assets.Stellar do
  @moduledoc """
  Implementation of the Stellar crypto functions for assets
  """

  alias Mintacoin.Assets.Crypto.AssetResponse
  alias Stellar.{Horizon, Horizon.Transaction, KeyPair, TxBuild}

  @type status :: :ok | :error
  @type stellar_response :: map()
  @type error :: {:error, any()}

  @behaviour Mintacoin.Assets.Crypto.Spec

  @impl true
  def create_asset(opts) do
    distributor_secret_key = Keyword.get(opts, :distributor_secret_key)
    issuer_secret_key = Keyword.get(opts, :issuer_secret_key)
    asset_code = Keyword.get(opts, :asset_code)
    asset_supply = Keyword.get(opts, :asset_supply)

    {issuer_pk, _issuer_secret_key} = issuer_keypair = KeyPair.from_secret_seed(issuer_secret_key)

    {distribution_pk, _sk} =
      distribution_keypair = KeyPair.from_secret_seed(distributor_secret_key)

    source_account = TxBuild.Account.new(issuer_pk)

    {:ok, seq_num} = Horizon.Accounts.fetch_next_sequence_number(issuer_pk)
    sequence_number = TxBuild.SequenceNumber.new(seq_num)

    asset = [code: asset_code, issuer: issuer_pk]

    trustline_operation =
      TxBuild.ChangeTrust.new(
        asset: asset,
        source_account: distribution_pk
      )

    create_payment_operation =
      TxBuild.Payment.new(
        destination: distribution_pk,
        asset: asset,
        amount: asset_supply,
        source_account: issuer_pk
      )

    issuer_signature = TxBuild.Signature.new(issuer_keypair)
    distribution_signature = TxBuild.Signature.new(distribution_keypair)

    {:ok, envelope} =
      source_account
      |> TxBuild.new(sequence_number: sequence_number)
      |> TxBuild.add_operation(trustline_operation)
      |> TxBuild.add_operation(create_payment_operation)
      |> TxBuild.sign([issuer_signature, distribution_signature])
      |> TxBuild.envelope()

    envelope
    |> Horizon.Transactions.create()
    |> format_response()
  end

  @spec format_response(tx_response :: {status(), stellar_response()}) ::
          {:ok, AssetResponse.t()} | error()
  defp format_response(
         {:ok,
          %Transaction{id: id, successful: successful, hash: hash, created_at: created_at} =
            tx_response}
       ) do
    {:ok,
     %AssetResponse{
       successful: successful,
       tx_id: id,
       tx_hash: hash,
       tx_timestamp: DateTime.to_string(created_at),
       tx_response: Map.from_struct(tx_response)
     }}
  end

  defp format_response({:error, response}), do: {:error, response}
end
