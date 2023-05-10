FROM ruby:3
ARG omejdn_version="unknown"

# Create container user
RUN groupadd -r containerUser && useradd -r -m -g containerUser containerUser

WORKDIR /opt

#Rebuild if Gemfile changed
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
RUN echo $omejdn_version > .version

COPY . .

EXPOSE 4567

# Change current user
USER containerUser

CMD [ "ruby", "omejdn.rb" ]
