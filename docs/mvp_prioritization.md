# Lemmy Dart Client MVP - Endpoint Prioritization

This document outlines the prioritization of Lemmy API endpoints for building an MVP (Minimum Viable Product) Dart client for Flutter applications. The focus is on core user functionality from a general user perspective, with admin and moderation features deferred to future releases.

## Overview

**Total Available Endpoints:** 142  
**MVP Target Endpoints:** ~45-55 endpoints across 5 stages

## Stage 1: Foundation & Authentication
**Priority: CRITICAL** | **Target: 8 endpoints**

Essential endpoints needed for any user interaction with a Lemmy instance.

### Authentication & Site Setup
- [x] `POST /account/auth/register` - Register new user (client.account.register())
- [x] `POST /account/auth/login` - User authentication (client.account.login())
- [x] `POST /account/auth/logout` - Session management (client.account.logout())
- [x] `GET /account/auth/get_captcha` - Handle registration captcha (client.account.captcha())
- [x] `GET /site` - Get instance info and user data (client.site.info())
- [x] `GET /account` - Get current user data (client.account.info())
- [x] `GET /account/validate_auth` - Validate auth tokens (client.account.validateToken())
- [x] `GET /account/unread_count` - Basic notification count (client.account.inbox.unread())

**Milestone:** Users can register, login, and access basic instance information.

---

## Stage 2: Content Consumption
**Priority: HIGH** | **Target: 12 endpoints**

Core endpoints for browsing and discovering content without interaction.

### Content Discovery
- [x] `GET /post/list` - Browse posts with filters (client.account.posts(), client.feed.posts(), client.community(id).posts())
- [x] `GET /post` - Fetch individual posts (client.post(id).info())
- [x] `GET /comment/list` - Get comments for posts (client.post(id).comments())
- [x] `GET /comment` - Fetch individual comments (client.comment(id).info())
- [x] `GET /community/list` - Discover communities (client.community.list())
- [x] `GET /community` - Get community details (client.community(id).info())
- [x] `GET /person` - View user profiles (client.user(id).info())
- [x] `GET /person/content` - View user's posts/comments (client.user(id).posts(), client.user(id).comments())

### Search & Navigation
- [ ] `GET /search` - Search across instance (client.post.search(), client.comment.search(), client.community.search(), etc.)
- [ ] `GET /modlog` - View moderation logs (client.site.modlog(), client.post(id).modlog(), client.user(id).modlog())
- [ ] `GET /federated_instances` - See federated instances (client.federation.instances())
- [ ] `GET /resolve_object` - Resolve federated content (client.federation.resolve())

**Milestone:** Users can browse, search, and discover content across the instance.

---

## Stage 3: Content Interaction
**Priority: HIGH** | **Target: 10 endpoints**

Basic user interactions with existing content.

### Voting & Engagement
- [ ] `POST /post/like` - Vote on posts (client.post(id).vote())
- [ ] `POST /comment/like` - Vote on comments (client.comment(id).vote())
- [ ] `PUT /post/save` - Save/unsave posts (client.post(id).save(), client.post(id).unsave())
- [ ] `PUT /comment/save` - Save/unsave comments (client.comment(id).save(), client.comment(id).unsave())
- [ ] `POST /post/mark_as_read` - Mark posts as read (client.post(id).read(), client.post(id).unread())

### Community Interaction
- [ ] `POST /community/follow` - Follow/unfollow communities (client.community(id).subscribe(), client.community(id).unsubscribe())
- [x] `GET /account/saved` - View saved content (client.account.posts(saved: true), client.account.comments(saved: true))
- [ ] `GET /account/read` - View read content

### Basic User Management
- [ ] `PUT /account/settings/save` - Update user settings
- [ ] `POST /account/mark_as_read/all` - Mark all notifications as read

**Milestone:** Users can interact with content through voting, saving, and following.

---

## Stage 4: Content Creation
**Priority: MEDIUM** | **Target: 12 endpoints**

Endpoints for creating and managing user-generated content.

### Post Creation & Management
- [ ] `POST /post` - Create new posts
- [ ] `PUT /post` - Edit posts
- [ ] `POST /post/delete` - Delete own posts
- [ ] `GET /post/site_metadata` - Fetch URL metadata for link posts

### Comment Creation & Management
- [ ] `POST /comment` - Create comments
- [ ] `PUT /comment` - Edit comments
- [ ] `POST /comment/delete` - Delete own comments
- [ ] `POST /comment/mark_as_read` - Mark specific comments as read

### Basic Media Support
- [ ] `POST /image` - Upload images
- [ ] `POST /account/avatar` - Upload user avatar
- [ ] `DELETE /account/avatar` - Remove user avatar
- [ ] `POST /account/banner` - Upload user banner

**Milestone:** Users can create, edit, and manage their own posts and comments with basic media support.

---

## Stage 5: Enhanced User Features
**Priority: LOW** | **Target: 15 endpoints**

Advanced features that enhance the user experience.

### Private Messaging
- [ ] `POST /private_message` - Send private messages
- [ ] `PUT /private_message` - Edit private messages
- [ ] `POST /private_message/mark_as_read` - Mark messages as read
- [ ] `POST /private_message/delete` - Delete messages

### Advanced Account Management
- [ ] `GET /account/inbox` - Get full inbox (replies, mentions, messages)
- [ ] `GET /account/hidden` - View hidden content
- [ ] `POST /account/mention/comment/mark_as_read` - Mark comment mentions as read
- [ ] `POST /account/mention/post/mark_as_read` - Mark post mentions as read
- [ ] `GET /account/settings/export` - Export user data
- [ ] `POST /account/settings/import` - Import user data

### Content Management
- [ ] `POST /post/hide` - Hide posts from feeds
- [ ] `POST /post/mark_as_read/many` - Bulk mark posts as read

### Community Features (Testing Support)
- [ ] `POST /community` - Create communities (for testing)
- [ ] `GET /community/random` - Get random community
- [ ] `POST /community/icon` - Upload community icon (for testing)

**Milestone:** Full-featured user experience with private messaging and advanced account management.

---

## Progress Tracking

### How to Mark Endpoints as Complete
To mark an endpoint as completed, change `- [ ]` to `- [x]` next to the endpoint.

### Stage Completion Status
- **Stage 1:** 0/8 endpoints completed
- **Stage 2:** 0/12 endpoints completed  
- **Stage 3:** 0/10 endpoints completed
- **Stage 4:** 0/12 endpoints completed
- **Stage 5:** 0/15 endpoints completed

**Overall MVP Progress:** 0/57 endpoints completed (0%)

---

## Future Considerations (Post-MVP)

### Moderation Features (Stage 6+)
- Community moderation endpoints
- Content reporting and resolution
- User blocking and instance blocking

### Administrative Features (Stage 7+)
- Site administration endpoints
- User management and banning
- Instance federation management

### Advanced Media Features (Stage 8+)
- Advanced media management
- Bulk media operations
- Media health checking

## Implementation Notes

1. **Error Handling:** Each stage should include robust error handling for network issues, authentication failures, and API errors.

2. **Caching Strategy:** Implement caching for frequently accessed data (posts, communities, user profiles) starting in Stage 2.

3. **Offline Support:** Consider offline reading capabilities for saved content starting in Stage 3.

4. **Testing:** Create comprehensive test coverage for each stage before moving to the next.

5. **Documentation:** Maintain clear documentation and examples for each implemented endpoint.

6. **Rate Limiting:** Implement proper rate limiting and request throttling from Stage 1.

---

**Total MVP Endpoints:** 57 endpoints (40% of available endpoints)  
**Estimated Development Time:** 8-12 weeks across all stages  
**Core Functionality Achievement:** Stage 3 completion provides a fully functional Lemmy client for general users. 