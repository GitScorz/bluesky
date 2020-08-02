# Contributing to Blue Sky Framework
To start off, thank you! This project wouldn't be what it is if it weren't for the amazing community around it building it to become an even better product. Seriously, you rock! 🤗

The following is a set of guidelines for contributing to Blue Sky Framework and its other resources, which are hosted in the [Blue Sky Roleplay Development organization]([https://github.com/BlueSky-Development](https://github.com/BlueSky-Development)) on GitHub. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

#### Table Of Contents
[Code of Conduct](#code-of-conduct)
[I don't want to read this whole thing, I just have a question!!!](#i-dont-want-to-read-this-whole-thing-i-just-have-a-question)

[Things To Know Before I Start](#things-to-know-before-i-start)
  * [Components](#components)

[How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
  * [Suggesting Enhancements](#suggesting-enhancements)
  * [Your First Code Contribution](#your-first-code-contribution)
  * [Pull Requests](#pull-requests)

[Styleguides](#styleguides)
  * [Git Commit Messages](#git-commit-messages)
  * [Lua Styleguide](#lua-styleguide)
  * [JavaScript Styleguide](#javascript-styleguide)
  * [Documentation Styleguide](#documentation-styleguide)

[Additional Notes](#additional-notes)
  * [Issue and Pull Request Labels](#labels)

## Code of Conduct

This project and everyone participating in it is governed by the [Blue Sky Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [abuse@blueskyrp.com](mailto:abuse@blueskyrp.com).

## I don't want to read this whole thing I just have a question!!!

> **Note:** Please do not use the GitHub issues as a place to ask a question. We have plenty of resources available where you can get better & faster answers.

Our forums is the better place to ask a question, head over there and ask away! https://blueskyrp.com/

If you'd rather chat, we have a public discord that you can join and our wonderful community is great at providing support. ::insert-discord-thingy::

## Things To Know Before I Start
This framework has been designed & coded for the use on Blue Sky's servers, so some design choices may be influenced by that. This also applies to approving pull requests as anything that is brought into this main repository will end up in the production servers.

### Components
The entirety of our base & resources are written in a component form, meanting all things are registered in the base as a component and retrieved through the base. This allows us to make it very easy to completely change how a component behaves without having to touch the original components code which in return makes it incredibly easy to distribute to anyone and make it plug & play.

 - Component Name Conventions: Be simple but descriptive, components names should follow [Upper Camel Case convention](https://wiki.c2.com/?UpperCamelCase)
 - Modify Original vs Create New: The basic rule is if you're fixing the component, update the original. If you're intentionally changing the behavior of the original create a new component. A great example of this is the [Spawn component defined in bs_characters](https://github.com/BlueSky-Development/FiveM-Framework/blob/master/bs_characters/client/spawn.lua)
 - Override vs Extending: If you're wanting to *add* functionality onto a component, extend it. If you're wanting to entirely replace a components functionality override it.
 - _protected: If you want to prevent your component from being overridden or extended, add _protected = true to your component. NOTE: This isn't an absolute guarantee that your component will not be overriden, just prevents accidental overrides or extensions.
 - _required: If you have certain functions or value needed in your component, largely used if your component is referenced in other components, define them in a table. Example: [cl_spawn](https://github.com/BlueSky-Development/FiveM-Framework/blob/master/bs_base/core/cl_spawn.lua#L2)

## How Can I Contribute?

### Reporting Bugs
This section will guide you through how to submit a *good* bug report. Submitting quality bug reports ensures the community understands the issue and can have a better chance at addressing the problems you're experiencing.

> NOTE: If you find a closed issue that you believe may be related to yours, open a new issue and link to it.

#### Before Submitting
- Check existing issues, duplicate issues will not make the issue get resolved faster.
- Check if you can find steps to reproduce your issue. Knowing the exact circumstances around the issue can make it much easier to fix it.
- Check if other platforms we offer have any discussion about your issue, this search doesn't need to be exhaustive but may help you fix your issues faster.

#### How to submit a *good* bug report?
We use [Github Issues](https://github.com/BlueSky-Development/FiveM-Framework/issues) to track any & all issues. While other social platforms we host may have areas for people to submit problems they will always route back to opening an issue on Github. Follow these simple guidelines and you bug report will help make this project better!
- __Use a clear & descriptive title__
- __Describe the exact steps you used to reproduce the issue__. If you weren't able to find exact steps to reproduce it do you best to explain circumstance around when you encountered the issue.
- __Provide specific examples for steps__
- __Describe what you *expected* after each step, and what results you actually got__

To provide additional context, try answer these questions:
- Do you have any custom components or have you modified existing ones?
- Can you reliably reproduce this issue?
- Are you on the most recent artifacts?
- Are you using OneSync or OneSync Infinity?

Include extra details such as (As Needed:
- OS & OS version server is running on
- Artifacts version
- MongoDB Version
- Server and/or Client hardware specs

### Suggesting Enhancements
This section will give you guidelines on what we expect when you request enhancements to the Blue Sky Framework or one of it's components that Blue Sky has developed.

Do note, as stated earlier this repository is the code that we use in our production FiveM server so any enhancements will go through additional scrutiny to ensure it's what we want in our server. if your feature is something you're wanting for your own server think about forking it.

#### Before Submitting A Suggestion
- Think about what impacts this may have on gameplay
- Think about what impacts this may have on performance, both client & server
- Does this in someway aid roleplay

#### How do I submit a *good* suggestion?
As with issues, follow these guidelines and you'll maximize the chances that the community can understand & implement your suggestion.
- __Use a clear & descriptive title__
- __Explain the issue that your suggestion aims to address__
- __Describe any possible downsides your suggestion *may* have__

### Your First Code Contribution

### Pull Requests

## Styleguides

### Git Commit Messages

### Lua Styleguide

### JavaScript Styleguide

### React Styleguide

### Documentation Styleguide

## Additional Notes

### Labels
