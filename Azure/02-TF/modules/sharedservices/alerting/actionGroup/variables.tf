variable "dutyPager" {
    type = object(
        {
            name = string
            service_uri = string
        }
    )
    default = {
      name = "PagerDutyWebhook"
      service_uri = "https://events.pagerduty.com/integration/3f3b3ab6defa4679bae3b3f9afab7d59/enqueue"
    }
    description = "If pager duty should not be used, set both to None"
}

variable "resourceGoupId" {
    type = string
    description = "Supply the resource id of the resource group"
}

variable "operationsEmailAddress" {
  type = string
  description = "Supply the email address where the notifications should be send"
  default = "nl-cloud-beheer@nl.clara.net"
}