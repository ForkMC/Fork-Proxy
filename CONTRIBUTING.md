Contributing to ForkMC
==========================
WaterfallMC has a very lenient policy towards PRs, but would prefer that you try and adhere to the following guidelines.

## Understanding Patches
Patches to ForkMC are very simple, but center around the directory 'ForkMC-Proxy'

Assuming you already have forked the repository:

1. Pull the latest changes from the main repository
2. Type `./forkmc p` in git bash to apply the changes from upstream
3. cd into `ForkMC-Proxy` for proxy changes

This directory is not a git repository in the traditional sense:

- Every single commit in ForkMC-Proxy is a patch.
- 'origin/master' points to a directory similar to ForkMC-Proxy but for ForkMC
- Typing `git status` should show that we are 10 or 11 commits ahead of master, meaning we have 10 or 11 patches that ForkMC, Waterfall, and Bungeecord don't
  - If it says something like `212 commits ahead, 207 commits behind`, then type `git fetch` to update ForkMC

## Adding Patches
Adding patches to ForkMC is very simple:

1. Modify `ForkMC-Proxy` with the appropriate changes
2. Type `git add .` to add your changes
3. Run `git commit` with the desired patch message
4. Run `./forkmc rb` in the main directory to convert your commit into a new patch
5. PR your patches back to this repository

Your commit will be converted into a patch that you can then PR into ForkMC

## Modifying Patches
Modifying previous patches is a bit more complex:

### Method 1
This method works by temporarily resetting HEAD to the desired commit to edit using rebase.

1. If you have changes you are working on type `git stash` to store them for later.
  - Later you can type `git stash pop` to get them back.
2. Type `git rebase -i upstream/upstream`
  - It should show something like [this](https://gist.github.com/Zbob750/e6bb220d3b734933c320).
3. Replace `pick` with `edit` for the commit/patch you want to modify, and "save" the changes.
  - Only do this for one commit at a time.
4. Make the changes you want to make to the patch.
5. Type `git add .` to add your changes.
6. Type `git commit --amend` to commit.
  - **MAKE SURE TO ADD `--amend`** or else a new patch will be created.
  - You can also modify the commit message here.
7. Type `git rebase --continue` to finish rebasing.
8. Type `./forkmc rb` in the main directory.
  - This will modify the appropriate patches based on your commits.
9. PR your modifications back to this project.

### Method 2 (sometimes easier)
If you are simply editing a more recent commit or your change is small, simply making the change at HEAD and then moving the commit after you have tested it may be easier.

1. Make your change while at HEAD
2. Make a temporary commit. You don't need to make a message for this.
3. Type `git rebase -i upstream/upstream`, move (cut) your temporary commit and move it under the line of the patch you wish to modify.
4. Change the `pick` with `f` (fixup) or `s` (squash) if you need to edit the commit message
5. Type `./forkmc rb` in the main directory.
  - This will modify the appropriate patches based on your commits.
6. PR your modifications to github


## PR Policy
We'll accept changes that make sense. You should be able to justify their existence, along with any maintenance costs that come with them. Remember, these changes will affect everyone who runs ForkMC, not just you and your server.
While we will fix minor formatting issues, you should stick to the guide below when making and submitting changes.

## Formatting
All modifications to non-ForkMC files should be marked
- Multi line changes start with `// ForkMC start` and end with `// ForkMC end`
- You can put a messages with a change if it isn't obvious, like this: `// ForkMC start - reason
  - Should generally be about the reason the change was made, what it was before, or what the change is
  - Multi-line messages should start with `// ForkMC start` and use `/* Multi line message here */` for the message itself
- Single line changes should have `// ForkMC` or `// ForkMC - reason`
- For example:
````java
return getConfig().getNotStupid(); // ForkMC - was return getConfig().getStupid();

// ForkMC start
// con.disconnect( bungee.getTranslation( "lost_connection" ) );
ServerInfo def = con.updateAndGetNextServer( server.getInfo() );
ServerKickEvent event = bungee.getPluginManager().callEvent( new ServerKickEvent( con, server.getInfo(), TextComponent.fromLegacyText( bungee.getTranslation( "lost_connection" ) ), def, ServerKickEvent.State.CONNECTED, ServerKickEvent.Cause.LOST_CONNECTION ) );
if ( event.isCancelled() && event.getCancelServer() != null )
{
    server.setObsolete( true );
    con.connectNow( event.getCancelServer() );
}
else
{
    con.disconnect0( event.getKickReasonComponent() );
}
// ForkMC end
````
- We generally follow usual java style, or what is programmed into most IDEs and formatters by default
  - This is also known as oracle style
  - It is fine to go over 80 lines as long as it doesn't hurt readability
  - There are exceptions, especially in Bungeecord-related files
  - When in doubt, use the same style as the surrounding code