defprotocol Robot do
  def advance(robot)

  def direction(robot)

  def position(robot)

  def turn_left(robot)

  def turn_right(robot)
end

defmodule Robot.North do
  defstruct [:position]
end

defmodule Robot.South do
  defstruct [:position]
end

defmodule Robot.East do
  defstruct [:position]
end

defmodule Robot.West do
  defstruct [:position]
end

defimpl Robot, for: Robot.North do
  def advance(%{position: {x, y}} = robot) do
    %{robot | position: {x, y + 1}}
  end

  def direction(_robot) do
    :north
  end

  def position(%{position: position}) do
    position
  end

  def turn_left(%{position: position}) do
    %Robot.West{position: position}
  end

  def turn_right(%{position: position}) do
    %Robot.East{position: position}
  end
end

defimpl Robot, for: Robot.South do
  def advance(%{position: {x, y}} = robot) do
    %{robot | position: {x, y - 1}}
  end

  def direction(_robot) do
    :south
  end

  def position(%{position: position}) do
    position
  end

  def turn_left(%{position: position}) do
    %Robot.East{position: position}
  end

  def turn_right(%{position: position}) do
    %Robot.West{position: position}
  end
end

defimpl Robot, for: Robot.East do
  def advance(%{position: {x, y}} = robot) do
    %{robot | position: {x + 1, y}}
  end

  def direction(_robot) do
    :east
  end

  def position(%{position: position}) do
    position
  end

  def turn_left(%{position: position}) do
    %Robot.North{position: position}
  end

  def turn_right(%{position: position}) do
    %Robot.South{position: position}
  end
end

defimpl Robot, for: Robot.West do
  def advance(%{position: {x, y}} = robot) do
    %{robot | position: {x - 1, y}}
  end

  def direction(_robot) do
    :west
  end

  def position(%{position: position}) do
    position
  end

  def turn_left(%{position: position}) do
    %Robot.South{position: position}
  end

  def turn_right(%{position: position}) do
    %Robot.North{position: position}
  end
end

defmodule RobotSimulator do
  def create(bearing \\ :north, position \\ {0, 0})

  def create(_bearing, position)
      when not (is_tuple(position) and tuple_size(position) == 2 and is_integer(elem(position, 0)) and
                  is_integer(elem(position, 1))) do
    {:error, "invalid position"}
  end

  def create(bearing, position) when bearing == :north do
    {:ok, %Robot.North{position: position}}
  end

  def create(bearing, position) when bearing == :south do
    {:ok, %Robot.South{position: position}}
  end

  def create(bearing, position) when bearing == :east do
    {:ok, %Robot.East{position: position}}
  end

  def create(bearing, position) when bearing == :west do
    {:ok, %Robot.West{position: position}}
  end

  def create(_bearing, _position) do
    {:error, "invalid direction"}
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

  defp execute_instruction(_instruction, {status, _robot}) when status == :error do
    {:error, "invalid instruction"}
  end

  defp execute_instruction(instruction, {_, robot}) when instruction == "A" do
    {:ok, Robot.advance(robot)}
  end

  defp execute_instruction(instruction, {_, robot}) when instruction == "L" do
    {:ok, Robot.turn_left(robot)}
  end

  defp execute_instruction(instruction, {_, robot}) when instruction == "R" do
    {:ok, Robot.turn_right(robot)}
  end

  defp execute_instruction(_instruction, _robot) do
    {:error, "invalid instruction"}
  end
end
