---
author: Naren
categories:
- cloud
- resiliency
- cost-optimization
- devops
date: '2026-04-16'
description: We are Nearly there on deep dive on resiliency Pattern - In this post
  will focus more on Tolerable Limit and Recovery Point Objective and why those matter
  on Architecting the DR Strategy for Infra failures !!!
draft: false
series:
- Resiliency Series
- RTO-RPO
tags:
- disaster-recovery
- dr
- aws
- cloud-architecture
- distributed-systems
- kubernetes
- patterns
- python
- resiliency
- sre
- architecture
- aws
- multi-region
title: 'Building Resilient Systems: Patterns & Approaches | RTO/RPO and Beyond'
---

### Right-Sizing: When Active-Passive Beats Active-Active

Here's a question I get constantly: "We have an RTO of 30 minutes and RPO of 5 minutes. Do we need cell-based architecture?"

**Short answer: No.**  You need something simpler and cheaper (probabaly 70%).

**Long answer: Let's talk about matching architecture** to actual requirements, not theoretical perfection.

- [Image credit to AWS]

![What is RTO RPO](/images/posts/resiliency/rto-rpo/RTO_APO.png)

#### The RTO/RPO Reality Check

How Tolerable limit and Point of failure objective plays a signifincant role on deciding what kind of resiliency we need and what it's actually going to cost.

![Resiliency Lens](/images/posts/resiliency/rto-rpo/resliency_lens_rto-rpo.png)

######  We will cover different Archiecture for each option but lets see at very high level how does it look like if we have RTO of 30 mins

If you can tolerate 30 minutes of downtime during a regional failure, you don't need multiple active cells. You need one active cell with fast automated recovery..

![30 min RTO Lens](/images/posts/resiliency/rto-rpo/30-min-RTO_View.png)

###### The Recovery Timeline for Active-Passive Setup

![Recovery Timeline](/images/posts/resiliency/rto-rpo/recovery_timeline.png)

###### When this Make sense

| Use Active-Passive if  | Use Active-Active Cells if |
| -------- | -------- | 
| ✅ RTO > 15 minutes is acceptable |✅ RTO < 5 minutes required|
|✅ RPO > 1 minute is acceptable |✅ RPO = 0 (no data loss acceptable)|
|✅ Cost optimization is a priority|✅ Global low-latency required|
|✅ Operational simplicity matters |✅ You can justify 3-4x cost increase|
|✅ You're not a trading platform or real-time payment system | ✅ You have the team to manage complexity|

##### The Cost Reality

![3 Years TCO Comparsion](/images/posts/resiliency/rto-rpo/3Year-TCO_Investment.png)

##### Decision Framework & Real World Example

![Decision framework](/images/posts/resiliency/rto-rpo/RTO-RPO-DecisionTree.png)

##### Real World Example for a Resiliency need of a medium size company vs Reality !!!

![Real World Example](/images/posts/resiliency/rto-rpo/rto-rpo-realworld-eample.png)

****

##### Implementation Checklist
If you decide Active-Passive is right:

##### Step 1: Primary Region

* Deploy full stack in primary region
* Implement Multi-AZ for HA
* Set up continuous backups
* Configure cross-region replication

##### Step 2: Standby Region

* Create infrastructure as code
* Deploy minimal standby resources
* Set up Aurora read replica
* Configure Auto Scaling (at 0)

##### Step 3: Automation

* Build failover automation (Lambda/Step Functions)
* Implement health checks
* Configure Route53 failover
* Create runbooks

##### Step 4: Testing

* Test failover (should complete in <30 min)
* Test failback
* Validate RPO (data loss <5 min)
* Document procedures

##### Ongoing:

* Quarterly DR drills
* Monthly standby validation
* Continuous cost optimization


### Key Takeaways
* Match architecture to requirements - Don't over-engineer
* RTO 30 min = Active-Passive - Not active-active cells
* 60-70% cost savings - Invest in features, not unused capacity
* 80% less complexity - Easier to operate and maintain
* Automation is critical - Manual processes won't meet 30-min RTO
* The Bottom Line
* Cell-based architecture is powerful, but it's not always the answer.

##### If you have relaxed RTO/RPO requirements (30 min / 5 min), you're over-engineering by 3-4x if you build active-active cells. Use that budget to:

* Hire more developers
* Build better features
* Improve monitoring
* Invest in automation

### Build what you need, not what sounds impressive on a whiteboard.