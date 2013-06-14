# trebuchet

A somewhat hacked-up library to allow avant-garde-ci to deploy to Amazon Elastic Beanstalk.

## status

Very much a work-in-progress for now.  I'm changing it from a CLI tool to a Gem, and then will be using it to write [avant-garde-ci](http://www.github.com/duncan-bayne/avant-garde-ci), which itself will start out as proof-of-concept code.

To be clear: *do not use this library for production work*. It should be considered proof-of-concept only.

## what does a trebuchet have to do with cloud deployment?

Watch [this video of a trebuchet being fired](http://www.youtube.com/watch?v=thiTa8wfZsc) and you'll understand :)

## licence

trebuchet is licensed under the GNU Lesser General Public License.

### why the LGPL?

The GPL is specifically designed to reduce the usefulness of GPL-licensed code to closed-source, proprietary software. The BSD license (and similar) don't mandate code-sharing if the BSD-licensed code is modified by licensees. The LGPL achieves the best of both worlds: an LGPL-licensed library can be incorporated within closed-source proprietary code, and yet those using an LGPL-licensed library are required to release source code to that library if they change it.
