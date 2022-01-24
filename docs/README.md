# iiifc-theme

- [Installation](#Installation)
  + [Prerequisites](#Prerequisites)
  + [Steps](#Steps)
- [Use](#Use)
  + [Configuration](#Configuration)
  + [Layouts](#Layouts)
    - [default.html](#defaulthtml)
    - [event.html](#eventhtml)
    - [page.html](#pagehtml)
    - [post.html](#posthtml)
    - [spec.html](#spechtml)
  + [Includes](#Includes)
- [Development](#Development)
  + [Norms](#Norms)
  + [Steps](#Steps-1)


## Installation

### Prerequisites

- `Ruby 2.7.2` with `Bundler`
- `Node >= 16` with `Yarn >= 1.22`

### Steps

1. Add the theme via GitHub to your Jekyll project's `Gemfile`:
  ``` ruby
  gem 'iiifc-theme', github: 'mnyrop/iiifc-theme', branch: 'main'
  ```
  > _**Note:** This will change to a IIIF org repo and use a tagged version instead of a branch name at the end of the development sprint._

2. Install with Bundler:
  ``` sh
  bundle install
  ```
3. And enable the theme in your `_config.yml`:

  ``` yaml
  theme: iiifc-theme
  ```

## Use

### Configuration

#### "Subsite" URL handling  
To use a "sub-site" repo (with shared theme and menu configuration to `IIIF/website`, e.g., `IIIF/api`), you will need to override one or more URLs defined in the theme's `_config.yml`.

The theme's `_config.yml` defines absolute, public, production URLs like so:

```yaml
# URLS
root_url:       https://iiif.io
api_url:        https://iiif.io/api
guides_url:     https://guides.iiif.io
```  

In your site repository, e.g., `IIIF/api`, you should override the appropriate URL (in this case `api_url`, to be local and relative):

```yaml
api_url:        /api
```

You should NOT need to define/override other URLs in the site's `_config.yml` UNLESS you want to "pair" your site to another version of the other site, e.g.,

```yaml
# URLS
root_url:       https://preview.iiif.io/root/wireframe/
api_url:        /api
```

If your site's content is NOT nested in a subdirectory (like `IIIF/api` is in `/api`) you should define the local url as blank, e.g.,

```yaml
guides_url:     ''
```

### Layouts

#### default.html
#### event.html
#### page.html
#### post.html
#### spec.html

```
TO DO
```

### Includes

```
TO DO
```

## Development

### Norms
- Follow [semantic versioning](https://semver.org/)
- Create namespaced branches, e.g., `feature/my-feature`
- Add issue numbers to branches where possible `chore/my-chore-12`
- Where possible, submit feature documentation with the feature itself

### Steps

1. Clone this repo and `cd` into it:
  ```sh
  git clone https://github.com/mnyrop/iiifc-theme.git && cd iiifc-theme
  ```
2. Install the Ruby dependencies
  ```sh
  bundle install
  ```
3. Install CSS and JS vendor dependencies
  ```sh
  yarn install
  ```
4. Make changes using your favorite text editor and preview them with
  ```sh
  bundle exec jekyll serve
  ```
