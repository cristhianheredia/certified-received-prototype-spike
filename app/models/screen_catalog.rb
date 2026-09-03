# Deterministic, seeded catalog — no DB, no randomness, no wall-clock (SPEC-prototype-review-
# environment.md §1.5, §6). This is Layer 1's registry: a screen "doesn't exist" for the harness
# until it's listed here (harness rule #3 in prototype-workflow-and-harness.md).
module ScreenCatalog
  Screen = Struct.new(:slug, :title, :summary, :device, :default_scenario, :scenarios, keyword_init: true)
  Scenario = Struct.new(:slug, :label, :description, :seed, :emails, keyword_init: true)
  Email = Struct.new(:id, :subject, :preview, :sent_at_label, :body_partial, keyword_init: true)

  SCREENS = {
    "claim" => Screen.new(
      slug: "claim",
      title: "Recipient — Claim delivery",
      summary: "Recipient types the invitation number they read in their email/SMS. Mobile-first (AC-21): the recipient arrives from an SMS on their phone.",
      device: :mobile,
      default_scenario: "waiting",
      scenarios: {
        "empty" => Scenario.new(
          slug: "empty",
          label: "Empty / first time",
          description: "Fresh account, nothing sent to this recipient yet.",
          seed: { recipient_name: "Jordan Blake", state: :empty },
          emails: []
        ),
        "waiting" => Scenario.new(
          slug: "waiting",
          label: "Invited, document waiting",
          description: "Recipient has an invitation number and hasn't claimed yet. Richest, most demonstrable state — this is the default.",
          seed: { recipient_name: "Jordan Blake", state: :waiting, invitation_number: "CR-7429-XQ2" },
          emails: [
            Email.new(
              id: "invitation",
              subject: "A document is waiting for you — action needed",
              preview: "Priya Shah sent you a certified document. Use invitation number CR-7429-XQ2 to claim it.",
              sent_at_label: "Just now",
              body_partial: "invitation"
            )
          ]
        ),
        "in_progress" => Scenario.new(
          slug: "in_progress",
          label: "In progress (reminder ladder running)",
          description: "Sent, TS1 logged, waiting on acknowledgment. A T+4 reminder has already gone out.",
          seed: { recipient_name: "Jordan Blake", state: :in_progress, invitation_number: "CR-7429-XQ2" },
          emails: [
            Email.new(
              id: "invitation",
              subject: "A document is waiting for you — action needed",
              preview: "Priya Shah sent you a certified document. Use invitation number CR-7429-XQ2 to claim it.",
              sent_at_label: "2 days ago",
              body_partial: "invitation"
            ),
            Email.new(
              id: "reminder_t4",
              subject: "Reminder: your document is still waiting",
              preview: "This is a reminder — the document sent to you hasn't been acknowledged yet.",
              sent_at_label: "4 hours ago",
              body_partial: "reminder"
            )
          ]
        ),
        "veteran" => Scenario.new(
          slug: "veteran",
          label: "Veteran, verified (R1)",
          description: "Recurring recipient, identity already verified, history populated. No new mail.",
          seed: { recipient_name: "Jordan Blake", state: :veteran },
          emails: []
        )
      }
    )
  }.freeze

  def self.find!(slug)
    SCREENS.fetch(slug) { raise ActionController::RoutingError, "Screen '#{slug}' is not registered in ScreenCatalog" }
  end
end
