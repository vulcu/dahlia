# Contributing

All contributions require a pull request. Only rebase merges are supported.
This project prioritizes computational efficiency and minimal memory size, for use with embedded systems.
All Pure Data contributions must be Pure Data vanilla compatible, and contributions requiring external Pure Data libraries will be rejected.

## Getting Started

This project is built with Pure Data 0.54 or later. PlugData 0.9.2 or later can also be used.

Recommended: Install [PlugData](https://github.com/plugdata-team/plugdata?tab=readme-ov-file#installation)
and follow README to install the latest PlugData version.

Clone the repository to the directory of your choice
```sh
git clone git@github.com:vulcu/dahlia.git
```

### Install Dependencies

After cloning the repo, navigate to the directory you cloned it into and follow
the [these steps](https://github.com/vulcu/dahlia/blob/main/docs/02.1.setup.dahlia.md#installation--setup-dahlia-python--hvcc) to install the required dependencies and libraries.

### Linting

PRs will not merge if they fail linting.
To confirm linting locally, run:

```sh
# linting is not currently enforced for this project
```

## Adding files

All code should be added to the relevant directory, e.g for Pure Data files this would be `dahlia/src/pd/<filename>.pd`.

### Documentation

- All contributions require written documentation or will be automatically rejected.
- Written documentation should be in the form of `*.md` markdown files conforming this [style guide](https://google.github.io/styleguide/docguide/style.html).

### Including Images

Images do not have to be optimized, however they should be of a reasonable filesize (2-5 MB is ideal).

You can add as many images as you like. The first image will be used as
the featured image at the top of the recipe and as the thumbnail image.

- Add images to `kicad-projects/[project]/images/[image-name][-##].jpg`
- Each image must have [alt text](https://www.w3.org/WAI/tutorials/images/informative/#example-2-images-used-to-supplement-other-information).
- Images may optionally have a photographer, source, and/or [license](https://spdx.org/licenses/).

### Required and Optional Details
