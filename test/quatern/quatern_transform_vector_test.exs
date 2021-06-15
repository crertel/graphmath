defmodule GraphmathTest.Quatern.TransformVector do
  use ExUnit.Case

  alias Graphmath.Quatern
  alias Graphmath.Vec3

  # x-axis
  @tag :quatern
  @tag :transform_vector
  test "transform_vector( +x axis 90 degrees, {1.0, 0.0, 0.0}) returns {1.0, 0.0, 0.0}" do
    sqrt_half = :math.sqrt(0.5)
    x_axis_90 = {sqrt_half, sqrt_half, 0.0, 0.0}
    vector = {1.0, 0.0, 0.0}
    assert Vec3.equal({1.0, 0.0, 0.0}, Quatern.transform_vector(x_axis_90, vector), 0.0001)
  end

  @tag :quatern
  @tag :transform_vector
  test "transform_vector( +x axis 90 degrees, {0.0, 1.0, 0.0}) returns {0.0, 0.0, 1.0}" do
    sqrt_half = :math.sqrt(0.5)
    x_axis_90 = {sqrt_half, sqrt_half, 0.0, 0.0}
    vector = {0.0, 1.0, 0.0}
    assert Vec3.equal({0.0, 0.0, 1.0}, Quatern.transform_vector(x_axis_90, vector), 0.0001)
  end

  @tag :quatern
  @tag :transform_vector
  test "transform_vector( +x axis 90 degrees, {0.0, 3.0, 0.0}) returns {0.0, 0.0, 3.0}" do
    sqrt_half = :math.sqrt(0.5)
    x_axis_90 = {sqrt_half, sqrt_half, 0.0, 0.0}
    vector = {0.0, 3.0, 0.0}
    assert Vec3.equal({0.0, 0.0, 3.0}, Quatern.transform_vector(x_axis_90, vector), 0.0001)
  end

  # y-axis
  @tag :quatern
  @tag :transform_vector
  test "transform_vector( +y axis 90 degrees, {0.0, 1.0, 0.0}) returns {0.0, 1.0, 0.0}" do
    sqrt_half = :math.sqrt(0.5)
    y_axis_90 = {sqrt_half, 0.0, sqrt_half, 0.0}
    vector = {0.0, 1.0, 0.0}
    assert Vec3.equal({0.0, 1.0, 0.0}, Quatern.transform_vector(y_axis_90, vector), 0.0001)
  end

  @tag :quatern
  @tag :transform_vector
  test "transform_vector( +y axis 90 degrees, {0.0, 1.0, 0.0}) returns {0.0, 0.0, 1.0}" do
    sqrt_half = :math.sqrt(0.5)
    y_axis_90 = {sqrt_half, 0.0, sqrt_half, 0.0}
    vector = {1.0, 0.0, 0.0}
    assert Vec3.equal({0.0, 0.0, -1.0}, Quatern.transform_vector(y_axis_90, vector), 0.0001)
  end

  @tag :quatern
  @tag :transform_vector
  test "transform_vector( +y axis 90 degrees, {0.0, 3.0, 0.0}) returns {0.0, 0.0, 3.0}" do
    sqrt_half = :math.sqrt(0.5)
    y_axis_90 = {sqrt_half, 0.0, sqrt_half, 0.0}
    vector = {3.0, 0.0, 0.0}
    assert Vec3.equal({0.0, 0.0, -3.0}, Quatern.transform_vector(y_axis_90, vector), 0.0001)
  end

  # z-axis
  test "transform_vector( +z axis 90 degrees, {0.0, 0.0, 1.0}) returns {0.0, 0.0, 1.0}" do
    sqrt_half = :math.sqrt(0.5)
    z_axis_90 = {sqrt_half, 0.0, 0.0, sqrt_half}
    vector = {0.0, 0.0, 1.0}
    assert Vec3.equal({0.0, 0.0, 1.0}, Quatern.transform_vector(z_axis_90, vector), 0.0001)
  end

  @tag :quatern
  @tag :transform_vector
  test "transform_vector( +z axis 90 degrees, {0.0, 1.0, 0.0}) returns {-1.0, 0.0, 0.0}" do
    sqrt_half = :math.sqrt(0.5)
    z_axis_90 = {sqrt_half, 0.0, 0.0, sqrt_half}
    vector = {0.0, 1.0, 0.0}
    assert Vec3.equal({-1.0, 0.0, 0.0}, Quatern.transform_vector(z_axis_90, vector), 0.0001)
  end

  @tag :quatern
  @tag :transform_vector
  test "transform_vector( +z axis 90 degrees, {0.0, 3.0, 0.0}) returns {-3.0, 0.0, 0.0}" do
    sqrt_half = :math.sqrt(0.5)
    z_axis_90 = {sqrt_half, 0.0, 0.0, sqrt_half}
    vector = {0.0, 3.0, 0.0}
    assert Vec3.equal({-3.0, 0.0, 0.0}, Quatern.transform_vector(z_axis_90, vector), 0.0001)
  end
end
