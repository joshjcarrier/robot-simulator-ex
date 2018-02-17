defmodule Robot do
  defstruct bearing: nil, position: nil

  def advance(%Robot{bearing: bearing, position: {x, y}}) when bearing == :north do
    %Robot{bearing: bearing, position: {x, y + 1}}
  end

  def advance(%Robot{bearing: bearing, position: {x, y}}) when bearing == :south do
    %Robot{bearing: bearing, position: {x, y - 1}}
  end

  def advance(%Robot{bearing: bearing, position: {x, y}}) when bearing == :east do
    %Robot{bearing: bearing, position: {x + 1, y}}
  end

  def advance(%Robot{bearing: bearing, position: {x, y}}) when bearing == :west do
    %Robot{bearing: bearing, position: {x - 1, y}}
  end

  def direction(%Robot{bearing: bearing}) do
    bearing
  end

  def position(%Robot{position: position}) do
    position
  end

  def turn_left(%Robot{bearing: bearing, position: position}) when bearing == :north do
    %Robot{bearing: :west, position: position}
  end

  def turn_left(%Robot{bearing: bearing, position: position}) when bearing == :south do
    %Robot{bearing: :east, position: position}
  end

  def turn_left(%Robot{bearing: bearing, position: position}) when bearing == :east do
    %Robot{bearing: :north, position: position}
  end

  def turn_left(%Robot{bearing: bearing, position: position}) when bearing == :west do
    %Robot{bearing: :south, position: position}
  end

  def turn_right(%Robot{bearing: bearing, position: position}) when bearing == :north do
    %Robot{bearing: :east, position: position}
  end

  def turn_right(%Robot{bearing: bearing, position: position}) when bearing == :south do
    %Robot{bearing: :west, position: position}
  end

  def turn_right(%Robot{bearing: bearing, position: position}) when bearing == :east do
    %Robot{bearing: :south, position: position}
  end

  def turn_right(%Robot{bearing: bearing, position: position}) when bearing == :west do
    %Robot{bearing: :north, position: position}
  end
end

defmodule RobotSimulator do
  def create(bearing \\ :north, position \\ {0, 0})

  def create(bearing, position)
      when bearing in [:north, :south, :east, :west] and is_tuple(position) and
             tuple_size(position) == 2 and is_integer(elem(position, 0)) and
             is_integer(elem(position, 1)) do
    {:ok, %Robot{bearing: bearing, position: position}}
  end

  def create(bearing, _position) when bearing not in [:north, :south, :east, :west] do
    {:error, "invalid direction"}
  end

  def create(_bearing, _position) do
    {:error, "invalid position"}
  end

  def direction({_, robot}) do
    Robot.direction(robot)
  end

  def position({_, robot}) do
    Robot.position(robot)
  end

  def simulate(robot_simulator, instructions) do
    instructions
    |> String.codepoints()
    |> Enum.reduce(robot_simulator, &execute_instruction/2)
  end

  def execute_instruction(_instruction, {status, _robot}) when status == :error do
    {:error, "invalid instruction"}
  end

  def execute_instruction(instruction, {_, robot}) when instruction == "A" do
    {:ok, Robot.advance(robot)}
  end

  def execute_instruction(instruction, {_, robot}) when instruction == "L" do
    {:ok, Robot.turn_left(robot)}
  end

  def execute_instruction(instruction, {_, robot}) when instruction == "R" do
    {:ok, Robot.turn_right(robot)}
  end

  def execute_instruction(_instruction, _robot) do
    {:error, "invalid instruction"}
  end
end
