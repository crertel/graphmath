defmodule Graphmath.Mat33.Tuple.Apply_Mat33 do
  use ExUnit.Case
  
  @tag :mat33
  @tag :apply
  test "apply( 1:1:9, {13,17,19} ) returns { 104, 251, 398} " do
    assert { 104, 251, 398 } == Graphmath.Mat33.Tuple.apply(    {1,2,3,
                                                                4,5,6,
                                                                7,8,9},
                                                                { 13, 17, 19 } )
  end
  
  @tag :mat33
  @tag :apply
  test "apply_left( 1:1:9, {13,17,19} ) returns { 104, 251, 398} " do
    assert { 214, 263, 312 } == Graphmath.Mat33.Tuple.apply_left(   {13, 17, 19 },
                                                                    {1,2,3,
                                                                    4,5,6,
                                                                    7,8,9})
  end
  
end
