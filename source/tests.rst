===============
Tests unitaires
===============

*************
Méthodologies
*************

(Copié/collé à partir de `ce lien <https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d#.kfyvxyb21>`_):

Why Bother with Test Discipline?
================================

Your tests are your first and best line of defense against software defects. Your tests are more important than linting & static analysis (which can only find a subclass of errors, not problems with your actual program logic). Tests are as important as the implementation itself (all that matters is that the code meets the requirement — how it’s implemented doesn’t matter at all unless it’s implemented poorly).

Unit tests combine many features that make them your secret weapon to application success:

 1. Design aid: Writing tests first gives you a clearer perspective on the ideal API design.
 2. Feature documentation (for developers): Test descriptions enshrine in code every implemented feature requirement.
 3. Test your developer understanding: Does the developer understand the problem enough to articulate in code all critical component requirements?
 4. Quality Assurance: Manual QA is error prone. In my experience, it’s impossible for a developer to remember all features that need testing after making a change to refactor, add new features, or remove features.
 5. Continuous Delivery Aid: Automated QA affords the opportunity to automatically prevent broken builds from being deployed to production.

Unit tests don’t need to be twisted or manipulated to serve all of those broad-ranging goals. Rather, it is in the essential nature of a unit test to satisfy all of those needs. These benefits are all side-effects of a well-written test suite with good coverage.

“What are you testing?”
===========================================

 1. What component aspect are you testing?
 2. What should the feature do? What specific behavior requirement are you testing?

**************
Quelques liens
**************

 * `Django factory boy <https://github.com/rbarrois/django-factory_boy/tree/v1.0.0>`_