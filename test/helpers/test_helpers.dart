import 'package:gotrek/features/auth/domain/entities/user_entity.dart';
import 'package:gotrek/features/auth/domain/repositories/auth_repository.dart';
import 'package:gotrek/features/auth/domain/usecases/login_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/signup_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/logout_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/register_usecase.dart';
import 'package:gotrek/features/trail/domain/entities/trail_entity.dart';
import 'package:gotrek/features/trail/domain/repositories/trail_repository.dart';
import 'package:gotrek/features/trail/domain/usecases/get_trails_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/get_trail_by_id_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/search_trails_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/get_popular_trails_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/join_trail_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/complete_trail_usecase.dart';
import 'package:gotrek/features/group/domain/entities/group_entity.dart';
import 'package:gotrek/features/group/domain/repositories/group_repository.dart';
import 'package:gotrek/features/group/domain/usecases/create_group.dart';
import 'package:gotrek/features/group/domain/usecases/get_groups.dart';
import 'package:gotrek/features/group/domain/usecases/get_group_by_id.dart';
import 'package:gotrek/features/group/domain/usecases/get_my_groups.dart';
import 'package:gotrek/features/group/domain/usecases/request_join_group.dart';
import 'package:gotrek/features/group/domain/usecases/manage_join_request.dart';
import 'package:gotrek/features/group/domain/usecases/get_pending_requests.dart';
import 'package:gotrek/features/group/domain/usecases/leave_group.dart';
import 'package:gotrek/features/group/domain/usecases/update_group.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<TrailRepository>(),
  MockSpec<GroupRepository>(),
  MockSpec<LoginUseCase>(),
  MockSpec<SignUpUseCase>(),
  MockSpec<RegisterUseCase>(),
  MockSpec<LogoutUseCase>(),
  MockSpec<GetCurrentUserUseCase>(),
  MockSpec<CheckAuthStatusUseCase>(),
  MockSpec<ChangePasswordUseCase>(),
  MockSpec<ForgotPasswordUseCase>(),
  MockSpec<ResetPasswordUseCase>(),
  MockSpec<UploadProfileImageUseCase>(),
  MockSpec<UpdateProfileUseCase>(),
  MockSpec<GetTrailsUseCase>(),
  MockSpec<GetTrailByIdUseCase>(),
  MockSpec<SearchTrailsUseCase>(),
  MockSpec<GetPopularTrailsUseCase>(),
  MockSpec<JoinTrailUseCase>(),
  MockSpec<CompleteTrailUseCase>(),
  MockSpec<CreateGroupUseCase>(),
  MockSpec<GetGroupsUseCase>(),
  MockSpec<GetGroupByIdUseCase>(),
  MockSpec<GetMyGroupsUseCase>(),
  MockSpec<RequestJoinGroupUseCase>(),
  MockSpec<ManageJoinRequestUseCase>(),
  MockSpec<GetPendingRequestsUseCase>(),
  MockSpec<LeaveGroupUseCase>(),
  MockSpec<UpdateGroupUseCase>(),
])
void _initMocks() {} // Annotation target for mock generation

// ============================================================================
// Test Data Factories
// ============================================================================

UserEntity createTestUser({
  String id = 'user-1',
  String name = 'Test User',
  String email = 'test@example.com',
  String role = 'user',
}) {
  return UserEntity(
    id: id,
    name: name,
    email: email,
    phone: '9800000000',
    hikerType: 'intermediate',
    bio: 'Test bio',
    profileImage: '',
    joinDate: DateTime(2024, 1, 1),
    role: role,
    subscription: 'Basic',
    stats: const UserStatsEntity(
      totalHikes: 5,
      totalDistance: 50.0,
      totalElevation: 2000.0,
      totalHours: 30.0,
      hikesJoined: 3,
      hikesLed: 2,
    ),
    achievements: const ['first_hike'],
    completedTrails: const [],
    joinedTrails: const [],
    groupsCount: 2,
  );
}

TrailEntity createTestTrail({
  String id = 'trail-1',
  String name = 'Annapurna Base Camp',
  String location = 'Kaski',
  double distance = 45.0,
  double elevation = 4130.0,
  TrailDifficulty difficulty = TrailDifficulty.moderate,
}) {
  return TrailEntity(
    id: id,
    name: name,
    location: location,
    distance: distance,
    elevation: elevation,
    difficulty: difficulty,
    description: 'A beautiful trek',
    highlights: const ['Mountain views', 'Hot springs'],
    images: const [],
    features: const ['Camping', 'Lodge'],
    seasons: const ['Spring', 'Autumn'],
    ratings: const [],
    averageRating: 4.5,
    numRatings: 100,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );
}

GroupEntity createTestGroup({
  String id = 'group-1',
  String name = 'ABC Trek Team',
  String trailId = 'trail-1',
  int maxParticipants = 10,
  GroupStatus status = GroupStatus.forming,
}) {
  return GroupEntity(
    odlId: id,
    odlName: name,
    odlDescription: 'A fun trek group',
    odlTrailId: trailId,
    odlTrailName: 'Annapurna Base Camp',
    odlStartDate: DateTime(2024, 6, 1),
    odlMaxParticipants: maxParticipants,
    odlStatus: status,
    odlParticipants: [
      GroupParticipant(
        odlUserId: 'user-1',
        odlUsername: 'Test Leader',
        odlRole: ParticipantRole.leader,
        odlJoinedAt: DateTime(2024, 1, 1),
      ),
    ],
    odlComments: const [],
    odlJoinRequests: const [],
    odlCreatorId: 'user-1',
    odlCreatedAt: DateTime(2024, 1, 1),
    odlUpdatedAt: DateTime(2024, 1, 1),
  );
}
