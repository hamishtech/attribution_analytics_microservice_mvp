## Running

You need Docker with Docker Compose installed.

```
make build
make bundle
make dbsetup
```

After that you can run following commands:

```
make server
make tests
make console
make bash
```

---

## Solution Description

### Pageview Endpoint

Endpoint stores the pageview in a **_Pageviews_** table.

For data validation, checks have been added to make sure that the `fingerprint` and `created_at` fields are not null. These fields are used in linking a pageviews back to an event or user.

The domain from the `referrer_url` has been parsed and added to the table. Additionally, if a pageview came from a marketing campaign `utm` fields are parsed from the url and added to the table. These additional fields provide more information for attribution analysis. Endpoint also checks for duplicates, in case the same webhook is fired twice.

### Event Endpoint

The event endpoint has been implemented similarly, it creates an Event in the **_Events_** table.

Checks have been added to make sure all fields are present. Maybe a check for `user_id` could be removed if we are tracking future events where there isn’t a `user_id` yet, but for our MVP I assumed that all events will have a `user_id`. The endpoint also checks for duplicates in case the same webhook is fired twice.

### Signup attribution endpoint

This endpoint aims to provide signup attribution information of a user. The endpoint finds the pageviews that led to a signup by querying all pageviews for a user's fingerprint before the date of their signup event. It then performs some analysis on the pageviews

It returns the following signup attribution information:

| Field                          | Description                                                                                                                                                                                                                                                                                                                                                                     |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sign_up_created_at`           | This information is useful in tracking and analyzing signup trends over time and helps in understanding the patterns and spikes in user signups.                                                                                                                                                                                                                                |
| `is_first_interaction_from_ad` | Tells us whether the user's first interaction with the site was from an advertisement. This metric provides valuable information about the impact of advertising campaigns in attracting users to the site and info on paid vs organic channels.                                                                                                                                |
| `first_interaction_url`        | Helps us find out which urls are most popular in driving traffic. Can help us understand which landing page is driving traffic.                                                                                                                                                                                                                                                 |
| `first_interaction_source`     | By identifying the domain of the referrer URL, we can gain a better understanding of which sources are driving traffic to Blinkist. For further depth we could have further categorized these sources into buckets (i.e. paid, search etc…)                                                                                                                                     |
| `first_ad`                     | This tells us which marketing campaign the user first encountered. This is important because it gives us insights into the campaign that attracted the user to Blinkist.                                                                                                                                                                                                        |
| `last_ad`                      | This tells us which marketing campaign the user was exposed to last. This information can tell us which marketing campaign pushed a user to sign up                                                                                                                                                                                                                             |
| `ad_count`                     | Number of ads that the user was exposed to                                                                                                                                                                                                                                                                                                                                      |
| `pageview_count`               | This gives us an idea about the user's engagement with the Blinkist before conversion. A high number of pageviews can indicate a high level of engagement and interest in Blinkist.                                                                                                                                                                                             |
| `time_to_conversion_seconds`   | This metric calculates the time it takes for a user to sign up after discovering the Blinkist. This can help us understand how quickly a user converts after discovering the Blinkist. Downside of this is we can’t be sure that the first pageview is indeed when they first discovered Blinkist. They might have already been used for a while on another device for example. |

I think that building brand awareness and making as many people discover Blinkist is one of the most important factors for Blinkist’s growth. Hence I think first-touch type of attribution analyses provide a lot of information on how the users are first discovering Blinkist.

For further depth we could perform other analyses such as multi touch which can give us more detail over the user’s funnel.

#### Future Technical Considerations/Todos

For **performance**, we could cache the signup attribution endpoint if there are multiple other microservices consuming the same data or add an event-driven system

For **scalability** - could add a load balancer and shard the databases by fingerprint for example. If our microservice is only focused on conversion/signups, we could also stop recording pageviews once the user has signed up. This would reduce writes on our database.

For **security purposes** we could add authentication in the form of API keys between the microservices

Add **monitoring** such as a health check to ensure the microservice is online and taking in requests

---

Please do not hesitate to contact me if you have further questions or encounter any technical issues. Thanks!
