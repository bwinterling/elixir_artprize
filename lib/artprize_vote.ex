# defmodule ArtprizeVote do
#   def add_vote(one, two, location, list) do
#     if in_range(location) do
#       list = list ++ [{one, two}]
#       {:ok, list}
#     else
#       {:err, "You must be in Grand Rapids to vote."}
#     end
#   end

#   defp in_range({lat, lon}) do
#     Enum.member?(-87.0..-84.0, lat) and Enum.member?(41.0..44.0, lon))
#   end
# end

# my version

# defmodule ArtprizeVote do
#   def start_server do
#     spawn(__MODULE__, :listen, [[]])
#   end
  
#   def listen(votes) do
#     receive do
#       { sender, :add_vote, {user_id, entry_id, coordinates}} ->
#         result = add_vote(user_id, entry_id, coordinates, votes)
#         {_, _, votes} = result
#         send sender, votes
#         listen(votes)
#     end
#   end

#   def add_vote(user, art, {lat, lng}, votes)
#     when lat < -84 and lat > -87 and lng > 41 and lng < 44 do
#       votes = votes ++ [{user, art}]
#     {:ok, "Successfully voted for entry, #{art}.", votes}
#   end

#   def add_vote({_user, _art, _loc, _votes}) do
#     {:err, "You must be in Grand Rapids to vote.", []}
#   end

  # def add_vote(user, art, {lat, lng}, votes)
  #   when lat < -84 and lat > -87 and lng > 41 and lng < 44 do
  #   {:ok, [{user, art} | votes]}
  # end

  # def add_vote(_user, _art, _loc, _votes) do
  #   {:err, "You must be in Grand Rapids to vote."}
  # end


  # #########################################
defmodule ArtprizeVote do
  def start_server do
    spawn(__MODULE__, :listen, [[]])
  end

  def listen(votes) do
    receive do
      {sender, :add_vote, {user_id, entry_id, coordinates}} ->
        result = add_vote(user_id, entry_id, coordinates, votes)
        {_, _, votes} = result
        send sender, result
        listen(votes)
      {sender, :get_votes} ->
        send sender, {:ok, votes}
        listen(votes)
      {sender, _} ->
        send sender, {:wtf}
        listen(votes)
    end
  end
  
  def calculate_winner(all_votes) do
    vote_count = tally_votes(all_votes)
    # IO.puts vote_count
  end

  defp tally_votes([ {user, art} | tail ]) do
    IO.puts "first: #{user}, tail: #{tail} "
    # tally_votes(all_votes, %{})
  end

  # defp tally_votes(all_votes, vote_count) do
  #   IO.puts "next"
  # end


  # -85.726469,42.906554,-85.55457,43.01148
  defp add_vote(_, _, {lat, lng}, votes)
  when not round(lat) in -87..-84 or not round(lng) in 41..44 do
    {:err, "You must be in Grand Rapids to vote.", votes}
  end

  defp add_vote(user_id, entry_id, _, votes)
  when is_integer(user_id) and is_integer(entry_id) do
    votes = votes ++ [{user_id, entry_id}]
    {:ok, "Successfully voted for entry, #{entry_id}.", votes}
  end
end
