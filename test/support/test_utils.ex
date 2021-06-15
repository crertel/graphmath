defmodule TestUtils do
  @very_smol 1.0e-10

  def within_eps(a,b) do
    abs(a-b) < @very_smol
  end
end
