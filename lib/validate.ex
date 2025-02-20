defmodule Fields.Validate do
  @moduledoc """
  Helper functions to validate the data in certain fields
  """

  @doc """
  Validate an address.
  Currently just validates that some input has been given.
  """
  def address(address) do
    String.length(address) > 0
  end

  @doc """
  Validate the format of an email address using a regex.
  Uses a slightly modified version of the w3c HTML5 spec email regex (https://www.w3.org/TR/html5/forms.html#valid-e-mail-address),
  with additions to account for not allowing emails to start or end with '.',
  and a check that there are no consecutive '.'s.
  """
  def email(email) do
    {:ok, regex} =
      Regex.compile(
        "^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]*(?<!\\.)@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
      )

    Regex.match?(regex, email) && !String.contains?(email, "..")
  end

  @doc """
  Validate the length of a name is less than 35 characters
  """
  def name(name) do
    len = String.length(name)
    1 < len && len < 35
  end

  @doc """
  Validates the format of a UK phone number.
  """
  def phone_number(phone) do
    regex =
      ~r/^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/

    Regex.match?(regex, phone)
  end

  @doc """
  Validate the format of an postcode using a regex.
  All existing postcodes in the UK should pass this validation;
  some non-existent ones may too if they follow the standard UK postcode format.
  """
  def postcode(postcode) do
    {:ok, regex} =
      Regex.compile(
        "^([A-Za-z][A-Za-z]?[0-9][A-Za-z0-9]? ?[0-9][A-Za-z]{2}|[Gg][Ii][Rr] ?0[Aa]{2})$"
      )

    Regex.match?(regex, postcode)
  end

  @doc """
  Validate the format of a url using a regex.
  See https://git.io/fpdad for details on how the regex for validation was chosen
  """
  def url(url) do
    {:ok, regex} =
      Regex.compile(
        "^(?:(?:https?|ftp)://)(?:\S+(?::\S*)?@)?(?:(?!10(?:\\.\d{1,3}){3})(?!127(?:\\.\d{1,3}){3})(?!169\\.254(?:\\.\d{1,3}){2})(?!192\\.168(?:\\.\d{1,3}){2})(?!172\\.(?:1[6-9]|2\d|3[0-1])(?:\\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:/[^\s]*)?$"
      )

    Regex.match?(regex, url)
  end

  def ip_address(ip_address) do
    # https://stackoverflow.com/questions/53497/regular-expression-that-matches-valid-ipv6-addresses
    {:ok, regex_ipv6} =
      Regex.compile(
        "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"
      )

    # https://stackoverflow.com/questions/5284147/validating-ipv4-addresses-with-regexp
    {:ok, regex_ipv4} = Regex.compile("((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}")
    Regex.match?(regex_ipv6, ip_address) || Regex.match?(regex_ipv4, ip_address)
  end
end
