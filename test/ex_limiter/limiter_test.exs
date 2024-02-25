defmodule ExLimiter.LimiterTest do
  use ExLimiter.DataCase

  alias ExLimiter.Limiter

  describe "requests" do
    alias ExLimiter.Limiter.Request

    import ExLimiter.LimiterFixtures

    @invalid_attrs %{url: nil}

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert Limiter.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Limiter.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      valid_attrs = %{url: "some url"}

      assert {:ok, %Request{} = request} = Limiter.create_request(valid_attrs)
      assert request.url == "some url"
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Limiter.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      update_attrs = %{url: "some updated url"}

      assert {:ok, %Request{} = request} = Limiter.update_request(request, update_attrs)
      assert request.url == "some updated url"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Limiter.update_request(request, @invalid_attrs)
      assert request == Limiter.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Limiter.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Limiter.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Limiter.change_request(request)
    end
  end
end
