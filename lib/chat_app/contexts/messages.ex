defmodule ChatApp.Contexts.Messages do

  def list_messages() do
    :ets.tab2list(:messages)
  end

  def get_message(id) do
    :ets.lookup(:messages, id)
  end

  def insert_message(message) do
    :ets.insert_new(:messages, message)
  end

  def delete_message(message) do
    :ets.delete(:messages, message)
  end

  def message_exists?(id) do
    :ets.member(:messages, id)
  end

end
