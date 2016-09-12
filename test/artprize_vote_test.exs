# defmodule ArtprizeVoteTest do
#   use ExUnit.Case

#   test "accepts votes in lat -87 - -84 and lng 41 - 44" do
#     result = ArtprizeVote.add_vote( 45, 67, { -85.6, 43.0 } , [] )

#     assert {:ok, [{ 45, 67 }]} = result
#   end

#   test "rejects votes outside of lat -87 - -84 or lng 41 - 44" do
#     result = ArtprizeVote.add_vote( 45, 67, { -85.6, 34.0 } , [] )

#     assert {:err, "You must be in Grand Rapids to vote."} = result
#   end
# end

# defmodule ArtprizeVoteTest do
#   use ExUnit.Case

#   test "accepts votes in lat -87 - -84 and lng 41 - 44" do
#     pid = ArtprizeVote.start_server
#     send pid, {self, :add_vote, {16, 69, {-85.6, 50}}}

#     assert_receive {:err, "You must be in Grand Rapids to vote.", []}
#   end

#   test "rejects votes outside of lat -87 - -84 or lng 41 - 44" do
#     pid = ArtprizeVote.start_server
#     send pid, {self, :add_vote, {16, 69, {-85.6, 43}}}

#     assert_receive {:ok, "Successfully voted for entry, 69.", [{16, 69}]}
#   end

#   test "properly reports vote counts" do
#     pid = ArtprizeVote.start_server
#     send pid, {self, :add_vote, {16, 69, {-85.6, 43}}}
#     send pid, {self, :add_vote, {16, 760, {-85.6, 43}}}
#     send pid, {self, :get_votes}

#     assert_receive {:ok, [{16, 69}, {16, 760}]}
#   end
# end

defmodule ArtprizeVoteTest do
  use ExUnit.Case

  test "accepts votes in lat -87 - -84 and lng 41 - 44" do
    pid = ArtprizeVote.start_server
    send pid, {self, :add_vote, {16, 69, {-85.6, 50}}}

    assert_receive {:err, "You must be in Grand Rapids to vote.", []}
  end

  test "rejects votes outside of lat -87 - -84 or lng 41 - 44" do
    pid = ArtprizeVote.start_server
    send pid, {self, :add_vote, {16, 69, {-85.6, 43}}}

    assert_receive {:ok, "Successfully voted for entry, 69.", [{16, 69}]}
  end

  test "properly reports vote counts" do
    pid = ArtprizeVote.start_server
    send pid, {self, :add_vote, {16, 69, {-85.6, 43}}}
    send pid, {self, :add_vote, {16, 760, {-85.6, 43}}}
    send pid, {self, :get_votes}

    assert_receive {:ok, [{16, 69}, {16, 760}]}
  end
  
  test "calculates the correct winner" do
    votes = [{1, 2}, {1, 3}, {2, 2}, {3, 2}, {4, 2}]
    assert ArtprizeVote.calculate_winner(votes) == {2, 4}
  end

end

# working version:

# defmodule ArtprizeVote do
#   def start_server do
#     Task.start_link(fn -> listen([]) end)
#   end

#   def listen(votes) do
#     receive do
#       {sender, :add_vote, {user_id, entry_id, coordinates}} ->
#         result = add_vote(user_id, entry_id, coordinates, votes)
#         {_, _, votes} = result
#         send sender, result
#         listen(votes)
#       {sender, :get_winner} ->
#         send sender, {:ok, calculate_winner(votes)}
#         listen(votes)
#       {sender, _} ->
#         send sender, {:wtf}
#         listen(votes)
#     end
#   end

#   defp add_vote(_, _, {lat, lng}, votes)
#   when not round(lat) in -87..-84 or not round(lng) in 41..44 do
#     {:err, "You must be in Grand Rapids to vote.", votes}
#   end

#   defp add_vote(user_id, entry_id, _, votes)
#   when is_integer(user_id) and is_integer(entry_id) do
#     votes = votes ++ [{user_id, entry_id}]
#     {:ok, "Successfully voted for entry, #{entry_id}.", votes}
#   end

#   def calculate_winner(votes) do
#     votes
#     |> unique_by_voter_and_entry
#     |> sum_per_entry(%{})
#     |> order_by_votes
#     |> Enum.at(0, %{})
#   end

#   def unique_by_voter_and_entry(votes), do: Enum.uniq votes

#   def sum_per_entry([], sums), do: sums
#   def sum_per_entry([{_, entry_id}|tail], sums) do
#     initial_value = Map.get(sums, entry_id, 0)
#     sums = Map.put(sums, entry_id, initial_value + 1)
#     sum_per_entry(tail, sums)
#   end

#   @doc """
#   Takes a list of {entry_id, entry_vote_count} tuples and orders them
#   in descending order by votes
#   # Example
#     iex> ArtprizeVote.order_by_votes([{2, 34}, {1, 50}, {3, 2}])
#     [{1, 50}, {2, 34}, {3, 2}]
#   """
#   def order_by_votes(sums) do
#     Enum.sort(sums, fn {_, sum_1}, {_, sum_2} -> sum_1 > sum_2 end)
#   end
# end
