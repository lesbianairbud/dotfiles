# sudofox/shell-mommy.sh

mommy() (

  # SHELL_MOMMYS_LITTLE - what to call you~ (default: "puppy")
  # SHELL_MOMMYS_PRONOUNS - what pronouns mommy will use for themself~ (default: "her")
  # SHELL_MOMMYS_ROLES - what role mommy will have~ (default "mommy")

  COLORS_LIGHT_PINK='\e[38;5;217m'
  COLORS_LIGHT_BLUE='\e[38;5;117m'
  COLORS_FAINT='\e[2m'
  COLORS_RESET='\e[0m'

  DEF_WORDS_LITTLE="puppy"
  DEF_WORDS_PRONOUNS="her"
  DEF_WORDS_ROLES="mommy"
  DEF_MOMMY_COLOR="${COLORS_LIGHT_PINK}"
  DEF_ONLY_NEGATIVE="false"

  NEGATIVE_RESPONSES="do you need MOMMYS_ROLE's help~? <3
Don't give up, my love~ <3
Don't worry, MOMMYS_ROLE is here to help you~ <3
I believe in you, my sweet AFFECTIONATE_TERM~ <3
It's okay to make mistakes, my dear~ <3
just a little further, sweetie~ <3
Let's try again together, okay~? <3
MOMMYS_ROLE believes in you, and knows you can overcome this~ <3
MOMMYS_ROLE believes in you~ <3
MOMMYS_ROLE is always here for you, no matter what~ <3
MOMMYS_ROLE is here to help you through it~ <3
MOMMYS_ROLE is proud of you for trying, no matter what the outcome~ <3
MOMMYS_ROLE knows it's tough, but you can do it~ <3
MOMMYS_ROLE knows MOMMYS_PRONOUN little AFFECTIONATE_TERM can do better~ <3
MOMMYS_ROLE knows you can do it, even if it's tough~ <3
MOMMYS_ROLE knows you're feeling down, but you'll get through it~ <3
MOMMYS_ROLE knows you're trying your best~ <3
MOMMYS_ROLE loves you, and is here to support you~ <3
MOMMYS_ROLE still loves you no matter what~ <3
You're doing your best, and that's all that matters to MOMMYS_ROLE~ <3
MOMMYS_ROLE is always here to encourage you~ <3"

  POSITIVE_RESPONSES="*pets your head*
awe, what a good AFFECTIONATE_TERM~\nMOMMYS_ROLE knew you could do it~ <3
good AFFECTIONATE_TERM~\nMOMMYS_ROLE's so proud of you~ <3
Keep up the good work, my love~ <3
MOMMYS_ROLE is proud of the progress you've made~ <3
MOMMYS_ROLE is so grateful to have you as MOMMYS_PRONOUN little AFFECTIONATE_TERM~ <3
I'm so proud of you, my love~ <3
MOMMYS_ROLE is so proud of you~ <3
MOMMYS_ROLE loves seeing MOMMYS_PRONOUN little AFFECTIONATE_TERM succeed~ <3
MOMMYS_ROLE thinks MOMMYS_PRONOUN little AFFECTIONATE_TERM earned a big hug~ <3
that's a good AFFECTIONATE_TERM~ <3
you did an amazing job, my dear~ <3
you're such a smart cookie~ <3"

  # allow for overriding of default words (IF ANY SET)

  if [ -n "$SHELL_MOMMYS_LITTLE" ]; then
    DEF_WORDS_LITTLE="${SHELL_MOMMYS_LITTLE}"
  fi
  if [ -n "$SHELL_MOMMYS_PRONOUNS" ]; then
    DEF_WORDS_PRONOUNS="${SHELL_MOMMYS_PRONOUNS}"
  fi
  if [ -n "$SHELL_MOMMYS_ROLES" ]; then
    DEF_WORDS_ROLES="${SHELL_MOMMYS_ROLES}"
  fi
  if [ -n "$SHELL_MOMMYS_COLOR" ]; then
    DEF_MOMMY_COLOR="${SHELL_MOMMYS_COLOR}"
  fi
  # allow overriding to true
  if [ "$SHELL_MOMMYS_ONLY_NEGATIVE" = "true" ]; then
    DEF_ONLY_NEGATIVE="true"
  fi
  # if the variable is set for positive/negative responses, overwrite it
  if [ -n "$SHELL_MOMMYS_POSITIVE_RESPONSES" ]; then
    POSITIVE_RESPONSES="$SHELL_MOMMYS_POSITIVE_RESPONSES"
  fi
  if [ -n "$SHELL_MOMMYS_NEGATIVE_RESPONSES" ]; then
    NEGATIVE_RESPONSES="$SHELL_MOMMYS_NEGATIVE_RESPONSES"
  fi

  # split a string on forward slashes and return a random element
  pick_word() {
    echo "$1" | tr '/' '\n' | shuf | sed 1q
  }

  pick_response() { # given a response type, pick an entry from the list

    if [ "$1" = "positive" ]; then
      element=$(echo "$POSITIVE_RESPONSES" | shuf | sed 1q)
    elif [ "$1" = "negative" ]; then
      element=$(echo "$NEGATIVE_RESPONSES" | shuf | sed 1q)
    else
      echo "Invalid response type: $1"
      exit 1
    fi

    # Return the selected response
    echo "$element"

  }

  sub_terms() { # given a response, sub in the appropriate terms
    response="$1"
    # pick_word for each term
    affectionate_term="$(pick_word "${DEF_WORDS_LITTLE}")"
    pronoun="$(pick_word "${DEF_WORDS_PRONOUNS}")"
    role="$(pick_word "${DEF_WORDS_ROLES}")"
    # sub in the terms, store in variable
    response="$(echo "$response" | sed "s/AFFECTIONATE_TERM/$affectionate_term/g")"
    response="$(echo "$response" | sed "s/MOMMYS_PRONOUN/$pronoun/g")"
    response="$(echo "$response" | sed "s/MOMMYS_ROLE/$role/g")"
    # we have string literal newlines in the response, so we need to printf it out
    # print faint and colorcode
    printf "${DEF_MOMMY_COLOR}$response${COLORS_RESET}\n"
  }

  success() {
    (
      # if we're only supposed to show negative responses, return
      if [ "$DEF_ONLY_NEGATIVE" = "true" ]; then
        return 0
      fi
      # pick_response for the response type
      response="$(pick_response "positive")"
      sub_terms "$response" >&2
    )
    return 0
  }
  failure() {
    rc=$?
    (
      response="$(pick_response "negative")"
      sub_terms "$response" >&2
    )
    return $rc
  }
  # eval is used here to allow for alias resolution

  # TODO: add a way to check if we're running from PROMPT_COMMAND to use the previous exit code instead of doing things this way
  eval "$@" && success || failure
  return $?
)
