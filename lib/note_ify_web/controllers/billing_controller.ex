defmodule NoteIfyWeb.BillingController do
  use NoteIfyWeb, :controller

  def index(conn, _params) do
    # Data needed for billing page
    user = %{
      name: "John Doe",
      email: "john@example.com"
    }

    current_plan = %{
      name: "Snail Mail",
      price: 9.99,
      status: "Active",
      features: [
        "Up to 5 postcards per month",
        "Basic postcard designs",
        "Weekly alert summaries",
        "Up to 3 webhook endpoints"
      ]
    }

    available_plans = [
      %{name: "Snail Mail", price: 9.99, description: "5 postcards", current: true},
      %{name: "Express Mail", price: 19.99, description: "15 postcards", current: false},
      %{name: "Priority Mail", price: 29.99, description: "Unlimited postcards", current: false}
    ]

    billing_history = [
      %{
        date: "May 1, 2025",
        description: "Monthly subscription - Snail Mail Plan",
        amount: 9.99,
        status: "paid"
      },
      %{
        date: "Apr 1, 2025",
        description: "Monthly subscription - Snail Mail Plan",
        amount: 9.99,
        status: "paid"
      },
      %{
        date: "Mar 1, 2025",
        description: "Monthly subscription - Snail Mail Plan",
        amount: 9.99,
        status: "paid"
      },
      %{
        date: "Feb 1, 2025",
        description: "Monthly subscription - Snail Mail Plan",
        amount: 9.99,
        status: "paid"
      }
    ]

    render(conn, :index,
      page_title: "Billing",
      user: user,
      current_plan: current_plan,
      available_plans: available_plans,
      billing_history: billing_history
    )
  end
end
